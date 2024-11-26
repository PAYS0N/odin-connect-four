# frozen_string_literal: true

module OdinConnectFour
  # class to manage user input
  class Player
    attr_accessor :char

    def grab_move(full_rows)
      prompt = "What row would you like to place a piece in?"
      error_msg = "Please enter a number from 1 to 7. The row must not be full."
      prep_proc = ->(x) { x.chomp.to_i }
      test = ->(num) { num.between?(1, 7) && !full_rows.include?(num - 1) }
      verify_input(prompt, error_msg, prep_proc, test)
    end

    def grab_char
      prompt = "What character would you like to use?"
      error_msg = "Please enter a single character."
      prep_proc = ->(x) { x.strip }
      test = ->(str) { str.length == 1 }
      verify_input(prompt, error_msg, prep_proc, test)
    end

    # pass text and a block to ask user for input that when the block returns true, the input is validated. returns valid
    # input as inputted string
    def verify_input(prompt, error_msg = "Invalid, try again.", prep_proc = ->(x) { x.chomp }, test = ->(val) { !val.empty? }) # rubocop:disable Layout/LineLength
      puts prompt
      input = prep_proc.call(gets)
      until test.call(input)
        puts error_msg
        input = prep_proc.call(gets)
      end
      input
    end
  end
end
