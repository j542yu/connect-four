# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#add_piece' do
    let(:current_player_piece) { '◌' }
    let(:column_idx) { 3 }
    let(:placeholder_piece) { 'X' } # previously filled pieces

    context 'when column is empty' do
      subject(:board_empty) { Board.new }

      it 'adds piece to bottom row' do
        board_empty.add_piece(column_idx, current_player_piece)

        column = board_empty.instance_variable_get(:@columns)[column_idx]
        bottom_row_idx = 5
        expect(column[bottom_row_idx]).to eq(current_player_piece)
      end

      it 'returns true for successfully adding piece' do
        expect(board_empty.add_piece(column_idx, current_player_piece)).to eq(true)
      end
    end

    context 'when column already has four pieces' do
      subject(:board_four_filled) { Board.new }
      let(:column) { board_four_filled.instance_variable_get(:@columns)[column_idx] }

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
      let(:column) { board_full.instance_variable_get(:@columns)[column_idx] }

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
end
