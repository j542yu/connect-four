# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  let(:current_player_piece) { '◌' }
  describe '#add_piece' do
    let(:column_idx) { 3 }
    let(:placeholder_piece) { 'X' } # previously filled pieces

    context 'when column is empty' do
      subject(:board_empty) { Board.new }

      it 'adds piece to bottom row' do
        board_empty.add_piece(column_idx, current_player_piece)

        column = board_empty.columns[column_idx]
        bottom_row_idx = 5
        expect(column[bottom_row_idx]).to eq(current_player_piece)
      end

      it 'returns true for successfully adding piece' do
        expect(board_empty.add_piece(column_idx, current_player_piece)).to eq(true)
      end
    end

    context 'when column already has four pieces' do
      subject(:board_four_filled) { Board.new }
      let(:column) { board_four_filled.columns[column_idx] }

      before do
        total_rows = 5 # indexed from 0
        4.times do |row_idx|
          column[total_rows - row_idx] = placeholder_piece
        end
      end

      it 'adds piece to second row' do
        board_four_filled.add_piece(column_idx, current_player_piece)
        second_row_idx = 1
        expect(column[second_row_idx]).to eq(current_player_piece)
      end

      it 'does not change previously placed pieces' do
        board_four_filled.add_piece(column_idx, current_player_piece)
        third_row_idx = 2 # random previously filled slot
        expect(column[third_row_idx]).to eq(placeholder_piece)
      end

      it 'returns true for successfully adding piece' do
        expect(board_four_filled.add_piece(column_idx, current_player_piece)).to eq(true)
      end
    end

    context 'when column is full' do
      subject(:board_full) { Board.new }
      let(:column) { board_full.columns[column_idx] }

      before do
        6.times do |row_idx|
          column[row_idx] = placeholder_piece
        end
      end

      it 'warns user' do
        expect(board_full).to receive(:warn_full_column)
        board_full.add_piece(column_idx, current_player_piece)
      end

      it 'does not change previously placed pieces' do
        board_full.add_piece(column_idx, current_player_piece)
        third_row_idx = 2 # random previously filled slot
        expect(column[third_row_idx]).to eq(placeholder_piece)
      end

      it 'returns false for failing to add piece' do
        expect(board_full.add_piece(column_idx, current_player_piece)).to eq(false)
      end
    end
  end

  describe '#display' do
    context 'when board is empty' do
      it 'prints empty board to command line' do
        board_empty = Board.new
        expected_output = <<~HEREDOC
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
        board_partially_filled = Board.new

        columns = board_partially_filled.columns

        random_column_idxs = [0, 2, 5, 6]

        random_column_idxs.each do |column_idx|
          columns[column_idx][5] = current_player_piece
        end

        expected_output = <<~HEREDOC
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
        board_full = Board.new

        columns = board_full.columns

        columns.each_with_index do |column, column_idx|
          column.each_index do |row_idx|
            columns[column_idx][row_idx] = current_player_piece
          end
        end

        expected_output = <<~HEREDOC
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
end
