require 'byebug'
require 'io/console'

module Checkers

  class Game
    attr_reader :board, :player1, :player2

    def initialize
      @board = Checkers::Board.new
      @player1 = Checkers::HumanPlayer.new(:R)
      self.setup
      play_turn
    end

    def play_turn

      color = @player1.color
      until @board.won?(color)
        start_pos, end_pos = get_move
        start_piece = @board[start_pos]
        # if start_piece.jump_move?(end_pos)
        #   while start_piece.jump_move?(end_pos) && start_piece.moves.any?
        #     start_piece.perform_moves(end_pos)
        #     start_pos, end_pos = get_move
        #     start_piece = @board[start_pos]
        #   end
        # else
        # end
        start_piece.perform_moves(end_pos)

        color = toggle_color(color)
      end
    end

    def get_move
      start_pos = kb_user_input(board)
      start_dup = [start_pos[0], start_pos[1]]
      dest_pos = kb_user_input(start_dup, board)
      start_piece = @board[start_pos]
      # raise InvalidMoveError unless start_piece.moves.include?(dest_pos)

      [start_pos, dest_pos]
    end

    def toggle_color(color)
      color == :B ? :R : :B
    end

    def setup
      input = prompt("Would you like to play against a (h)uman or (c)computer?")
      @player2 = HumanPlayer.new(:B) if input == 'h'
      @player2 = ComputerPlayer.new if input == 'c'
    end

    def kb_user_input(current_pos = [0,0], board)
      system('clear')
      board.render_cursor(current_pos)
      input = STDIN.getch

      unless input == "\r"
        system('clear')
        case input
        when 'w'
          current_pos[0] -= 1 if current_pos[0].between?(1,7)
        when 'a'
          current_pos[1] -= 1 if current_pos[1].between?(1,7)
        when 's'
          current_pos[0] += 1 if current_pos[0].between?(0,6)
        when 'd'
          current_pos[1] += 1 if current_pos[1].between?(0,6)
        when 'q'
          exit
        end

        kb_user_input(current_pos, board)
      end

      system('clear')
      current_pos
    end

    def prompt(prompt)
      puts prompt
      input = gets.chomp.downcase
    end

    # def get_coords(prompt)
    #   puts prompt
    #   input = gets.chomp.split(',').map(&:to_i)
    # end
  end

  class HumanPlayer
    attr_reader :color

    def initialize(color)
      @color = color
    end
  end

  class ComputerPlayer

  end
end
