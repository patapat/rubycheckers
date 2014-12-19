
module Checkers

  class Game

    def initalize
      @board = Board.new
      @player1 = HumanPlayer.new
    end

    def play_turn

      color = player1.color
      until board.won?(color)
        begin
          start_pos = get_coords("Select piece:")
          dest_pos = get_coords("Select tile:")
          start_piece = @board[start_pos]

          start_piece.perform_moves
        rescue
          retry
        end


        color = toggle_color(color)
    end

    def toggle_color(color)
      color == :B ? :R : :B
    end

    def setup
      input = prompt("Would you like to play against a (h)uman or (p)layer?")
      @player2 = HumanPlayer.new if input == 'h'
      @player2 = ComputerPlayer.new if input == 'c'
    end

    def prompt(prompt)
      puts prompt
      input = gets.chomp.downcase
    end

    def get_coords(prompt)
      puts prompt
      input = gets.chomp.split(',').map(&:to_i)
    end
  end

  class HumanPlayer

    def initialize
      @color = color
    end
  end

  class ComputerPlayer

  end
end
