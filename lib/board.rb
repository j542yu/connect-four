# frozen_string_literal: true

# This class represents a Connect Four game board.
#
# It handles storing the positions of the pieces in the board,
# adding new pieces, and displaying the board to the command line.
class Board
  def initialize
    @columns = Array.new(7) { Array.new(6) } # 7 columns, each with 6 slots
  end

  def add_piece(column_idx, player_piece)
    column = @columns[column_idx]

    highest_filled_row_idx = 0

    highest_filled_row_idx += 1 while highest_filled_row_idx < 6 && column[highest_filled_row_idx].nil?

    if highest_filled_row_idx.zero?
      -1 # out of bounds idx to show failed addition of piece
    else
      row_idx = highest_filled_row_idx - 1
      column[row_idx] = player_piece
      row_idx
    end
  end

  def display
    puts '  1   2   3   4   5   6   7'
    6.times do |row_idx|
      print '|'
      @columns.each do |column|
        print column[row_idx].nil? ? '   |' : " #{column[row_idx]} |"
      end
      print "\n——————————————————————————————\n"
    end
  end

  # each pair is [column, row] with positive being right and down
  DIRECTIONS = [
    [[1, 0], [-1, 0]], # horizontal
    [[0, 1]], # vertical (down only since pieces are stacked on top of each other)
    [[-1, 1], [1, -1]], # left-to-right diagonal ↙ ↗
    [[1, 1], [-1, -1]] # right-to-left diagonal ↘ ↖
  ].freeze

  def four_in_a_row?(last_move, player_piece)
    DIRECTIONS.any? { |direction_set| count_consecutive(last_move, direction_set, player_piece) >= 4 }
  end

  def full?
    @columns.all? { |column| !column[0].nil? }
  end

  private

  def count_consecutive(last_move, direction_set, player_piece) # rubocop:disable Metrics/MethodLength
    count = 1 # last move counts as first piece

    direction_set.each do |direction|
      next_column = last_move[0] + direction[0]
      next_row = last_move[1] + direction[1]

      while next_column.between?(0, 6) && next_row.between?(0, 5) && @columns[next_column][next_row] == player_piece
        count += 1

        next_column += direction[0]
        next_row += direction[1]
      end
    end

    count
  end
end
