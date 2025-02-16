# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  let(:current_player_piece) { '◌' }

  describe '#add_piece' do
    let(:column_idx) { 3 }
    let(:placeholder_piece) { 'X' } # previously filled pieces

    context 'when column is empty' do
      subject(:board_empty) { described_class.new }
      let(:bottom_row_idx) { 5 }

      it 'adds piece to bottom row' do
        board_empty.add_piece(column_idx, current_player_piece)

        column = board_empty.instance_variable_get(:@columns)[column_idx]
        expect(column[bottom_row_idx]).to eq(current_player_piece)
      end

      it 'returns bottom row idx in which piece was added' do
        expect(board_empty.add_piece(column_idx, current_player_piece)).to eq(bottom_row_idx)
      end
    end

    context 'when column already has four pieces' do
      subject(:board_four_filled) { described_class.new }
      let(:column) { board_four_filled.instance_variable_get(:@columns)[column_idx] }
      let(:second_row_idx) { 1 }

      before do
        total_rows = 5 # indexed from 0
        4.times do |row_idx|
          column[total_rows - row_idx] = placeholder_piece
        end
      end

      it 'adds piece to second row' do
        board_four_filled.add_piece(column_idx, current_player_piece)

        expect(column[second_row_idx]).to eq(current_player_piece)
      end

      it 'returns second row idx in which piece was added' do
        expect(board_four_filled.add_piece(column_idx, current_player_piece)).to eq(second_row_idx)
      end

      it 'does not change previously placed pieces' do
        board_four_filled.add_piece(column_idx, current_player_piece)
        third_row_idx = 2 # random previously filled slot
        expect(column[third_row_idx]).to eq(placeholder_piece)
      end
    end

    context 'when column is full' do
      subject(:board_full) { described_class.new }
      let(:column) { board_full.instance_variable_get(:@columns)[column_idx] }

      before do
        6.times do |row_idx|
          column[row_idx] = placeholder_piece
        end
      end

      it 'does not change previously placed pieces' do
        board_full.add_piece(column_idx, current_player_piece)
        third_row_idx = 2 # random previously filled slot
        expect(column[third_row_idx]).to eq(placeholder_piece)
      end

      it 'returns -1 for failing to add piece' do
        expect(board_full.add_piece(column_idx, current_player_piece)).to eq(-1)
      end
    end
  end

  describe '#display' do
    context 'when board is empty' do
      it 'prints empty board to command line' do
        board_empty = described_class.new
        expected_output = <<~HEREDOC
            1   2   3   4   5   6   7
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
        HEREDOC

        expect { board_empty.display }.to output(expected_output).to_stdout
      end
    end

    context 'when board is partially filled' do
      it 'prints correct partially filled board' do
        board_partially_filled = described_class.new

        columns = board_partially_filled.instance_variable_get(:@columns)

        random_column_idxs = [0, 2, 5, 6]

        random_column_idxs.each do |column_idx|
          columns[column_idx][5] = current_player_piece
        end

        expected_output = <<~HEREDOC
            1   2   3   4   5   6   7
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          |   |   |   |   |   |   |   |
          ——————————————————————————————
          | ◌ |   | ◌ |   |   | ◌ | ◌ |
          ——————————————————————————————
        HEREDOC

        expect { board_partially_filled.display }.to output(expected_output).to_stdout
      end
    end

    context 'when board is full' do
      it 'prints full board' do
        board_full = described_class.new

        columns = board_full.instance_variable_get(:@columns)

        columns.each_with_index do |column, column_idx|
          column.each_index do |row_idx|
            columns[column_idx][row_idx] = current_player_piece
          end
        end

        expected_output = <<~HEREDOC
            1   2   3   4   5   6   7
          | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ |
          ——————————————————————————————
          | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ |
          ——————————————————————————————
          | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ |
          ——————————————————————————————
          | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ |
          ——————————————————————————————
          | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ |
          ——————————————————————————————
          | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ | ◌ |
          ——————————————————————————————
        HEREDOC

        expect { board_full.display }.to output(expected_output).to_stdout
      end
    end
  end

  describe '#four_in_a_row?' do
    context 'when player has four horizontal pieces in a row' do
      it 'returns true' do
        board_horizontal = described_class.new
        columns = board_horizontal.instance_variable_get(:@columns)

        random_row_idx = 4
        random_column_idxs = [3, 4, 5, 6]

        random_column_idxs.each do |random_column_idx|
          columns[random_column_idx][random_row_idx] = current_player_piece
        end

        # picked random move as 'last' since player wouldn't always draw continuous line in game
        last_move = [random_column_idxs[2], random_row_idx]

        expect(board_horizontal.four_in_a_row?(last_move, current_player_piece)).to eq(true)
      end
    end

    context 'when player has four vertical pieces in a row' do
      it 'returns true' do
        board_vertical = described_class.new
        columns = board_vertical.instance_variable_get(:@columns)

        random_column_idx = 2
        random_row_idxs = [0, 1, 2, 3]

        random_row_idxs.each do |random_row_idx|
          columns[random_column_idx][random_row_idx] = current_player_piece
        end

        # unlike the other tests, the last move is actually last since can only stack vertical pieces one by one
        last_move = [random_column_idx, random_row_idxs[0]]

        expect(board_vertical.four_in_a_row?(last_move, current_player_piece)).to eq(true)
      end
    end

    context 'when player has four right-to-left (↘ ↖) diagnoal pieces in a row' do
      it 'returns true' do
        board_right_to_left = described_class.new
        columns = board_right_to_left.instance_variable_get(:@columns)

        diagonal_column_idxs = [2, 3, 4, 5]
        diagnoal_row_idxs = [0, 1, 2, 3]

        4.times do |i|
          columns[diagonal_column_idxs[i]][diagnoal_row_idxs[i]] = current_player_piece
        end

        # picked random move as 'last' since player wouldn't always draw continuous line in game
        last_move = [diagonal_column_idxs[2], diagnoal_row_idxs[2]]

        expect(board_right_to_left.four_in_a_row?(last_move, current_player_piece)).to eq(true)
      end
    end

    context 'when player has four left-to-right (↙ ↗) diagnoal pieces in a row' do
      it 'returns true' do
        board_left_to_right = described_class.new
        columns = board_left_to_right.instance_variable_get(:@columns)

        diagonal_column_idxs = [2, 3, 4, 5]
        diagnoal_row_idxs = [3, 2, 1, 0]

        4.times do |i|
          columns[diagonal_column_idxs[i]][diagnoal_row_idxs[i]] = current_player_piece
        end

        # picked random move as 'last' since player wouldn't always draw continuous line in game
        last_move = [diagonal_column_idxs[2], diagnoal_row_idxs[2]]

        expect(board_left_to_right.four_in_a_row?(last_move, current_player_piece)).to eq(true)
      end
    end

    context 'when player has three horizontal in a row and one vertical (L shape)' do
      it 'returns false' do
        board_l = described_class.new
        columns = board_l.instance_variable_get(:@columns)

        random_row_idxs = [4, 4, 4, 3]
        random_column_idxs = [3, 4, 5, 6]

        4.times do |i|
          columns[random_column_idxs[i]][random_row_idxs[i]] = current_player_piece
        end

        # picked random move as 'last' since player wouldn't always draw continuous line in game
        last_move = [random_column_idxs[2], random_row_idxs[2]]

        expect(board_l.four_in_a_row?(last_move, current_player_piece)).to eq(false)
      end
    end

    context 'when player has four diagonal in a row but not in a straight line (^ shape)' do
      it 'returns false' do
        board_triangle = described_class.new
        columns = board_triangle.instance_variable_get(:@columns)

        diagonal_column_idxs = [0, 1, 2, 3]
        diagnoal_row_idxs = [2, 1, 0, 1]

        4.times do |i|
          columns[diagonal_column_idxs[i]][diagnoal_row_idxs[i]] = current_player_piece
        end

        # picked random move as 'last' since player wouldn't always draw continuous line in game
        last_move = [diagonal_column_idxs[2], diagnoal_row_idxs[2]]

        expect(board_triangle.four_in_a_row?(last_move, current_player_piece)).to eq(false)
      end
    end
  end

  describe '#full?' do
    context 'when board is full' do
      it 'returns true' do
        board_full = described_class.new

        columns = board_full.instance_variable_get(:@columns)

        columns.each_with_index do |column, column_idx|
          column.each_index do |row_idx|
            columns[column_idx][row_idx] = current_player_piece
          end
        end

        expect(board_full).to be_full
      end
    end

    context 'when board is not full' do
      it 'returns false' do
        board_partially_filled = described_class.new

        columns = board_partially_filled.instance_variable_get(:@columns)

        random_column_idxs = [0, 2, 5, 6]

        random_column_idxs.each do |column_idx|
          columns[column_idx][5] = current_player_piece
        end

        expect(board_partially_filled).not_to be_full
      end
    end
  end
end
