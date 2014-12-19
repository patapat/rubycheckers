require 'byebug'

module Checkers

  class Piece
    attr_reader :color, :board, :promoted, :icon
    attr_accessor :position

    BLACK_MOVES = {
      :slide => [[1, 1], [1, -1]],
      :jump => [[2, 2], [2, -2]]
      }

    RED_MOVES = {
      :slide => [[-1, 1], [-1, -1]],
      :jump => [[-2, 2], [-2, -2]]
      }

    UNICODE_ICONS = {
      :weak_snow    => "\u2603",
      :strong_snow  => "\u26C4",
      :weak_sun     => "\u26C5",
      :strong_sun   => "\u2600"
      }

    def initialize(position, color, board)
      @position = position
      @color = color
      @board = board
      @promoted = false
      @icon = (color == :B ? UNICODE_ICONS[:weak_sun] : UNICODE_ICONS[:weak_snow])
    end

    def perform_jump(dest)
      return false unless (self.moves.include?(dest)) && ((dest[0] - position[0]).abs != 1)
      enemy_pos = [(position[0] + dest[0]) / 2, (position[1] + dest[1]) / 2]
      board[enemy_pos] = nil
      make_move(dest)

      true
    end

    def perform_slide(dest)
      return false unless self.moves.include?(dest) && (dest[0] - position[0]).abs == 1
      make_move(dest)

      true
    end

    def make_move(dest)
      board[position] = nil
      self.position = dest
      board[dest] = self
      maybe_promote
    end

    def perform_moves(moves)
      valid_move_seq?(moves) ? perform_moves!(moves) : false
    end

    def perform_moves!(move)
      return false unless perform_slide(move) || perform_jump(move)
      # moves.each do |move|
      #   if moves.count == 1
      #     return false unless perform_slide(move) || perform_jump(move)
      #   else
      #     return false unless perform_jump(move)
      #   end
      # end

      true
    end

    def valid_move_seq?(moves)
      duped_board = board.deep_dup
      duped_board[position].perform_moves!(moves)
    end

    def find_pos(pos)
      x, y = pos
      new_pos = [position[0] + x, position[1] + y]
    end

    def inspect
      "#{color}"
    end

    def move_dirs #return all possible directions
      if color == :B
        poss_dirs = BLACK_MOVES
      elsif color == :R
        poss_dirs = RED_MOVES
      elsif self.promoted
        poss_dirs = BLACK_MOVES + RED_MOVES
      end

      poss_dirs
    end

    def moves #return array of all possible moves
      poss_moves = []


      move_dirs[:slide].each_with_index do |slide_move, i|
        dest = find_pos(slide_move)
        if enemy_piece?(dest)
          test_pos = find_pos(move_dirs[:jump][i])
          poss_moves << test_pos if empty_space?([test_pos])
        elsif empty_space?(dest)
          poss_moves << dest
        end
      end

      poss_moves.select { |move| board.valid_pos?(move) }
    end

    def jump_move?(pos)
      (position[0] - pos[0]).abs == 2
    end

    def empty_space?(pos)
      board[pos].nil?
    end

    def enemy_piece?(pos)
      !board[pos].nil? && board[pos].color != self.color
    end

    def maybe_promote
      if color == :B && position[0] == 7
        self.promoted = true
        self.icon = UNICODE_ICONS[:strong_sun]
      elsif color == :R && position[0] == 0
        self.promoted = true
        self.icon = UNICODE_ICONS[:strong_snowman]
      end
    end

  end
end
