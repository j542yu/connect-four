# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:player_one) { double('Player', piece: '◌', name: 'Player 1') }
  let(:player_two) { double('Player', piece: '●', name: 'Player 2') }
  let(:board) { double('Board') }

  before do
    allow($stdout).to receive(:write) # avoid seeing print/puts statement when testing
  end

  describe '#ask_for_valid_column' do
    subject(:game_input) { described_class.new([player_one, player_two], board) }
    let(:valid_value) { '2' }

    context 'when user inputs two incorrect values, then a valid value' do
      let(:letter) { 's' }
      let(:out_of_bound_idx) { '8' }

      before do
        allow(game_input).to receive(:gets).and_return(letter, out_of_bound_idx, valid_value)
      end

      it 'completes loop and displays error message twice' do
        expect(game_input).to receive(:warn_invalid_column_idx).twice
        game_input.send(:ask_for_valid_column)
      end

      it 'returns valid input received' do
        valid_column_idx = valid_value.to_i - 1
        expect(game_input.send(:ask_for_valid_column)).to eq(valid_column_idx)
      end
    end

    context 'when user inputs valid value' do
      before do
        allow(game_input).to receive(:gets).and_return(valid_value)
      end

      it 'never displays error message' do
        expect(game_input).not_to receive(:warn_invalid_column_idx)
        game_input.send(:ask_for_valid_column)
      end

      it 'returns valid input received' do
        valid_column_idx = valid_value.to_i - 1
        expect(game_input.send(:ask_for_valid_column)).to eq(valid_column_idx)
      end
    end
  end

  describe '#add_piece' do
    subject(:game_add) { described_class.new([player_one, player_two], board) }
    let(:valid_result) { 4 }
    let(:valid_column_idx) { 2 } # assume column idx 2 is not full
    let(:invalid_column_idx) { 3 } # assume column idx 3 is full

    context 'when user chooses a valid (not full) column' do
      before do
        allow(board).to receive(:add_piece).and_return(valid_result)
      end

      it 'calls Board#add_piece once' do
        expect(board).to receive(:add_piece).once
        game_add.send(:add_piece, valid_column_idx)
      end
    end

    context 'when user chooses a full column, then a valid (not full) column' do
      before do
        invalid_result = -1
        allow(board).to receive(:add_piece).and_return(invalid_result, valid_result)

        allow(game_add).to receive(:ask_for_valid_column).and_return(valid_column_idx)
      end

      it 'calls Board#add_piece twice' do
        expect(board).to receive(:add_piece).twice
        game_add.send(:add_piece, invalid_column_idx)
      end

      it 're-prompts the user for a new input' do
        expect(game_add).to receive(:ask_for_valid_column).once
        game_add.send(:add_piece, invalid_column_idx)
      end

      it 'completes loop and displays error message once' do
        expect(game_add).to receive(:warn_full_column).once
        game_add.send(:add_piece, invalid_column_idx)
      end
    end
  end
end
