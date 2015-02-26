require 'colorize'
require_relative 'piece'

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
		nil
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