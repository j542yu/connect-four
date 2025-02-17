# Connect-Four Game

## Overview

Note: This project was created as part of The Odin Project's Ruby course in their Ruby on Rails path. The specific goal of this particular project was to practice Test Driven Development (TDD), thus why the Rspec files are included.

Connect Four is a classic two-player game where players take turns dropping circular pieces into a vertical grid. The goal is to be the first to connect four of your pieces in a row—horizontally, vertically, or diagonally—before your opponent does.

## **Setting Up the Game**

This implementation is written in Ruby (version 3.3.5).

### **Running Locally**
1. **Install Ruby**: Follow the official installation guide [here](https://www.ruby-lang.org/en/documentation/installation/).
2. **Clone the Repository**:
   - [Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) this repository.
   - [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) your forked repo to your local machine.
3. **Install Dependencies**:
   - Open a terminal and navigate to the project directory.
   - Run `bundle install` to install the required gems, including the _rainbow_ gem for colorful text output.
4. **Start the Game**:
   - Run `ruby main.rb` to launch the game and follow the on-screen instructions.

### **Running Remotely**
Use a remote environment like [Replit.com](https://replit.com) by uploading the project files and running `ruby main.rb`.

## Game Rules

* The game starts with an empty 7x6 board.

* Players take turns dropping a piece into one of the 7 columns.

* A piece will fall to the lowest available row in the selected column.

* The game continues until:

    * A player connects four pieces in a row (win condition).
    * The board is full (resulting in a draw).

* The winner is declared as soon as a four-in-a-row sequence is formed.

## Features

* Turn-Based Gameplay: Players alternate turns, choosing a column to drop their piece.

* Automatic Win Detection: The game detects when a player has won by aligning four pieces in any direction.

* Draw Detection: If the board is full and no player has won, the game declares a draw.

* RSpec Testing: The project follows Test-Driven Development (TDD) principles, ensuring that all game logic is covered by automated tests.
