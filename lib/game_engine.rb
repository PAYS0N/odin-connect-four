# frozen_string_literal: true

module OdinConnectFour
  # central logic for running connect four game
  class GameEngine
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

    private

    def intro_game
      puts "The goal of connect four is to get 4 of your color in a horizontal,"
      puts "vertical, or diagonal row. Enter the number of the column you want"
      puts "to place your piece in."
    end
  end
end
