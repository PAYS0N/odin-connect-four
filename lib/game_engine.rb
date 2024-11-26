# frozen_string_literal: true

require_relative("player")

module OdinConnectFour
  # central logic for running connect four game
  class GameEngine
    def initialize
      @game_state = [[], [], [], [], [], [], []]
      @player = OdinConnectFour::Player.new
    end

    def play_game
      intro_game
      rounds = 0
      game_over = false
      until game_over || rounds == 42
        game_over = play_round
        rounds += 1
      end
      puts "player1 wins"
    end

    def play_round
      move = @player.grab_move - 1
      @game_state[move].push(@player.char)
      game_over?(move)
      true
    end

    def game_over?(row)
      height = @game_state[row].length
      char = @game_state[row][height - 1]
      correct = [0, 0, 0, 0]
      [[-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1], [1, 0], [1, 1]].each_with_index do |change, index|
        x, y = change
        while @game_state[row + x][height + y - 1] == char
          correct[index % 4] += 1
          x += change[0]
          y += change[1]
        end
      end
      correct.reduce(false) { |acc, curr| acc || (curr >= 3) }
    end

    private

    def intro_game
      puts "The goal of connect four is to get 4 of your color in a horizontal,"
      puts "vertical, or diagonal row. Enter the number of the column you want"
      puts "to place your piece in."
    end
  end
end
