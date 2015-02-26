require 'colorize'
require_relative 'piece'
require 'byebug'

class Board
	GRID_SIZE = 8
	attr_reader :grid

	def initialize
		@grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) }
	end

	def setup_board

	end

	def render
		grid.each_with_index do |row, i|
			print "#{i} "
			row.each_with_index do |position, j|
				background = ((i + j).even? ? :white : :black)
				if self[[i, j]].nil?
					print '  '.colorize(:background => background)
				else
					print self[[i, j]].show.colorize(:background => background)
				end
			end
			puts
		end
		puts "   0 1 2 3 4 5 6 7"
		nil
	end

	def move(start_pos, end_pos)
		place_piece(end_pos, self[start_pos])
		self[start_pos] = nil
	end

	def place_piece(pos, piece)
		self[pos] = piece
		piece.board = self
		piece.position = pos
	end

	def size
		GRID_SIZE
	end

	def [](pos)
		x, y = pos
		grid[x][y]
	end

	def []=(pos, piece)
		x, y = pos
		grid[x][y] = piece
	end
end