# frozen_string_literal: true

require_relative 'lib/game'

print "Hey there, want to play Connect Four? (y/n)\n=> "
input = nil
loop do
  loop do
    input = gets.chomp
    break if %w[y n].include?(input)

    puts "\nInvalid input. Type 'y' to play or 'n' to exit."
  end

  if input == 'y'
    puts "\nGreat! Here we go!"
    Game.new.play
  else
    puts "\nOkay... Byebye :("
    exit
  end

  print "\nPlay again? (y/n)\n=> "
end
