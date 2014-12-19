require_relative "./board.rb"
require_relative "./game.rb"
require_relative "./piece.rb"
require 'byebug'

module Checkers

end

b = Checkers::Board.new
b.fill_start_board
red_pawn = b[[5,4]]
red_pawn.perform_slide([4,3])
red_pawn.moves
