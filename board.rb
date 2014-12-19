require 'byebug'
require 'colorize'
require 'io/console'

module Checkers

  class Board
    attr_reader :grid

    def initialize
      @grid = Array.new(8) { Array.new(8) }
      self.fill_start_board
      @pieces_remaining = {:B => 12, :R => 12}
    end

    def [](pos)
      x, y = pos
      self.grid[x][y]
    end

    def []=(pos, piece)
      x, y = pos
      @grid[x][y] = piece
    end


    def fill_start_board
      @grid.count.times do |row|
        @grid.count.times do |col|
          next if (row.even? && col.even?) || (row.odd? && col.odd?)
          if row.between?(0,2)
            @grid[row][col] = Checkers::Piece.new([row, col], :B, self)
          elsif row.between?(5,7)
            @grid[row][col] = Checkers::Piece.new([row, col], :R, self)
          end
        end
      end

    end


    def won?(color)
      opp_color = (color == :B ? :R : :B)
      return true if @grid.flatten.compact.none? { |piece| piece.color == opp_color }
      false
    end

    def render_cursor(coords)
      system('clear')

      8.times do |row|
        8.times do |col|
          if row == coords[0] && col == coords[1]
            print "  ".colorize( :background => :yellow )
          else
            if (row.odd? && col.odd?) || (row.even? && col.even?)
              if @grid[row][col].nil?
                print '  '.colorize(:background => :red)
              else
                print (@grid[row][col].icon + ' ').colorize(:background => :red)
              end
            else
              if @grid[row][col].nil?
                print '  '.colorize(:background => :black)
              else
                print (@grid[row][col].icon + ' ').colorize(:background => :black)
              end
            end
          end
        end
        puts
      end
      print coords
    end

    def valid_pos?(pos)
      pos.all? { |x| x.between?(0,7) } && !pos.all? { |y| y.even? } && !pos.all? { |z| z.odd? }
    end

    def deep_dup
      duped_board = Checkers::Board.new
      @grid.count.times do |row|
        @grid.count.times do |col|
          next if self[[row, col]].nil?
          duped_board[[row, col]] = Piece.new([row, col], @grid[row][col].color, duped_board)
        end
      end

      duped_board
    end
  end
end
