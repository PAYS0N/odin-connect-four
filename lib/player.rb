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
  end
end
