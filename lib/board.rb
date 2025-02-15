# frozen_string_literal: true

require 'rainbow/refinement'
using Rainbow

# This class represents a Connect Four game board.
#
# It handles storing the positions of the pieces in the board,
# adding new pieces, and displaying the board to the command line.
class Board
  def initialize(player_one_piece = '◌', player_two_piece = '●')
    @columns = Array.new(7) { Array.new(6) } # 7 columns, each with 6 slots
    @player_one_piece = player_one_piece
    @player_two_piece = player_two_piece
  end

  def add_piece(column_idx, player_piece)
    column = @columns[column_idx]

    highest_filled_row_idx = 0

    highest_filled_row_idx += 1 while highest_filled_row_idx < 6 && column[highest_filled_row_idx].nil?

    if highest_filled_row_idx.zero?
      warn_full_column
      false
    else
      column[highest_filled_row_idx - 1] = player_piece
      true
    end
  end

  def warn_full_column
    puts 'This column is full. You cannot add a piece here.'.red.bg(:silver)
  end
end
