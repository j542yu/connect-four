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

  attr_reader :columns, :player_one_piece, :player_two_piece

  def add_piece(column_idx, player_piece) # rubocop:disable Metrics/MethodLength
    column = columns[column_idx]

    highest_filled_row_idx = 0

    highest_filled_row_idx += 1 while highest_filled_row_idx < 6 && column[highest_filled_row_idx].nil?

    if highest_filled_row_idx.zero?
      warn_full_column
      -1 # out of bounds idx to show failed addition of piece
    else
      row_idx = highest_filled_row_idx - 1
      column[row_idx] = player_piece
      row_idx
    end
  end

  def warn_full_column
    puts 'This column is full. You cannot add a piece here.'.red.bg(:silver)
  end

  def display
    6.times do |row_idx|
      print '|'
      columns.each do |column|
        print column[row_idx].nil? ? '   |' : " #{column[row_idx]} |"
      end
      print "\n——————————————————————————————\n"
    end
  end
end
