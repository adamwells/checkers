require 'byebug'

class Piece
	attr_reader :color
	attr_accessor :board, :position

	def initialize(color, position = nil, board = nil)
		@color = color
		@board = board
		@king = false
		@position = position
	end

	def king?
		@king
	end

	def show
		symbol = (king? ? 'K ' : 'P ')
		symbol.colorize(color)
	end

	def perform_slide(current_pos, next_pos)
		x, y = current_pos
		move_diffs.each do |move|
			dx, dy = move
			offset = [x + dx, y + dy]
			if offset == next_pos && @board[offset].nil?
				@board.move(current_pos, next_pos)
				return true
			end
		end
		false
	end

	def perform_jump(current_pos, next_pos)
		x, y = current_pos
		move_diffs.each do |move|
			dx, dy = move
			offset = [x + (dx * 2), y + (dy * 2)]
			if offset == next_pos && @board[offset].nil?
				unless @board[[x + dx, y + dy]].nil? || @board[[x + dx, y + dy]].color == color
					@board.move(current_pos, next_pos)
					return true
				end
			end
		end
		false
	end

	def move_diffs
		if color == :green
			[[1, -1], [1, 1]]
		else
			[[-1, -1], [-1, 1], [-2, -2], [-2, 2]]
		end
	end

	def maybe_promote
	end
end