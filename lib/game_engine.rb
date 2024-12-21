# frozen_string_literal: true

require_relative("player")

module OdinConnectFour
  # central logic for running connect four game
  class GameEngine
    def initialize
      @game_state = [[], [], [], [], [], [], []]
      @player1 = OdinConnectFour::Player.new
      @player2 = OdinConnectFour::Player.new
      @active_player = @player1
    end

    def play_game
      intro_game
      setup_players
      rounds = 0
      game_over = false
      until game_over || rounds == 42
        display_game
        game_over = play_round
        rounds += 1
      end
      end_game(game_over)
    end

    def play_round
      full = []
      @game_state.each_with_index { |arr, index| full.push(index) if arr.length == 6 }
      move = @active_player.grab_move(full) - 1
      @game_state[move].push(@active_player.char)
      @active_player = @active_player == @player1 ? @player2 : @player1
      game_over?(move)
    end

    def setup_players
      @player1.setup
      @player2.setup
    end

    def game_over?(row)
      height = @game_state[row].length
      char = @game_state[row][height - 1]
      correct = [0, 0, 0, 0]
      [[-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1], [1, 0], [1, 1]].each_with_index do |change, index|
        x, y = change
        while (row + x).between?(0, @game_state.size - 1) &&
              (height + y - 1).between?(0, @game_state[row + x].size - 1) &&
              @game_state[row + x][height + y - 1] == char
          correct[index % 4] += 1
          x += change[0]
          y += change[1]
        end
      end
      correct.reduce(false) { |acc, curr| acc || (curr >= 3) }
    end

    def end_game(game_over)
      display_game
      if game_over
        puts "#{(@active_player == @player1 ? @player2 : @player1).char} wins"
      else
        puts "It was a tie!"
      end
    end

    private

    def intro_game
      puts "The goal of connect four is to get 4 of your color in a horizontal,"
      puts "vertical, or diagonal row. Enter the number of the column you want"
      puts "to place your piece in."
    end

    def display_game
      puts "|1|2|3|4|5|6|7|"
      5.downto(0) do |i|
        @game_state.each do |col|
          if col.length > i
            print "|#{col[i]}"
          else
            print "| "
          end
        end
        puts "|"
      end
    end
  end
end
