# frozen_string_literal: true

# This class represents a player in a game of Connect Four.
#
# It stores each player's piece symbol and name.
class Player
  def initialize(piece, player_id)
    @piece = piece
    @name = ask_for_name(player_id)
  end

  attr_reader :piece, :name

  private

  def ask_for_name(player_id)
    puts "Player #{player_id}, what's your name?"
    gets.chomp
  end
end
