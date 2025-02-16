# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

require 'rainbow/refinement'
using Rainbow

# This class represents a round of Connect Four
#
# It handles the game logic, including taking turns
# between players and determining when the game ends
class Game
  def initialize(players = [Player.new('◌', 1), Player.new('●', 2)], board = Board.new)
    @players = players
    @board = board
    @current_player_id = 0
    @last_move = nil
    @winner = nil
  end

  def play
    announce_intro
    until game_over?
      current_player_make_move
      check_for_winner
      switch_players
    end
    announce_conclusion
  end

  private

  def check_for_winner
    @winner = @board.four_in_a_row?(@last_move, current_player.piece) ? current_player : nil
  end

  def game_over?
    @winner || @board.full?
  end

  def current_player
    @players[@current_player_id]
  end

  def current_player_make_move
    display_turn_info
    column_idx = ask_for_valid_column
    add_piece(column_idx)
    show_move_result(column_idx)
  end

  def switch_players
    @current_player_id = 1 - @current_player_id
  end

  def ask_for_valid_column
    loop do
      print '=> '
      column_idx = gets.chomp.to_i - 1
      return column_idx if column_idx.between?(0, 6)

      warn_invalid_column_idx
    end
  end

  def add_piece(column_idx)
    row_idx = @board.add_piece(column_idx, current_player.piece)
    while row_idx.negative?
      warn_full_column
      column_idx = ask_for_valid_column
      row_idx = @board.add_piece(column_idx, current_player.piece)
    end
    @last_move = [column_idx, row_idx]
  end

  def show_move_result(column_idx)
    puts "\n#{current_player.name} dropped their piece in column #{column_idx + 1}!"
    @board.display
  end

  def warn_invalid_column_idx
    puts '' # add new line without highlighting entire line when using Rainbow gem
    puts 'Invalid column number. Please choose an integer number from 1 to 7.'.red.bg(:silver)
  end

  def warn_full_column
    puts '' # add new line without highlighting entire line when using Rainbow gem
    puts 'This column is full, you cannot add a piece here. Please pick another column!'.red.bg(:silver)
  end

  def display_turn_info
    puts "#{current_player.name}, enter the column number in which you want to drop your piece!".blue
  end

  def announce_intro
    intro = <<~HEREDOC

      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      Welcome to Connect Four!

      In this game, each player takes turn dropping down their game piece in one of the 7 columns.

      The first to get four in a row in a straight line wins! This includes horizontal, vertical, and diagonal lines.

      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    HEREDOC

    puts intro.green
    puts 'Here is what the board looks like:'
    @board.display
  end

  def announce_conclusion
    if @winner.nil?
      puts "\nIts a tie! There are no more slots left and no player has won.".green
    else
      puts "\nYay, #{@winner.name} won!!! Cake for the winner 🎂 :>".green
    end
  end
end
