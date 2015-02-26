require 'byebug'
require 'colorize'

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

	def possibly_move(current_pos, next_pos)
		perform_slide(current_pos, next_pos) || perform_jump(current_pos, next_pos)
	end

	def perform_slide(current_pos, next_pos)
		if possible_moves(current_pos).include?(next_pos) && @board[next_pos].nil?
			board.move(current_pos, next_pos)
			return true
		end
		false
	end

	def perform_jump(current_pos, next_pos)
		spot_between = [(current_pos[0] + next_pos[0]) / 2, (current_pos[1] + next_pos[1]) / 2]
		if possible_moves(current_pos).include?(next_pos) && @board[next_pos].nil?
			unless @board[spot_between].nil? || @board[spot_between].color == color
				@board.move(current_pos, next_pos)
				@board[spot_between] = nil
				return true
			end
		end
		false
	end

	def possible_moves(position)
		x, y = position
		slides = move_diffs.map do |diff|
			dx, dy = diff
			[x + dx, y + dy]
		end

		jumps = move_diffs.map do |diff|
			dx, dy = diff
			[x + (dx * 2), y + (dy * 2)]
		end

		(jumps + slides).select do |pos|
			pos.max < board.size and pos.min >= 0
		end
	end

	def move_diffs
		if color == :green
			[[1, -1], [1, 1]]
		else
			[[-1, -1], [-1, 1]]
		end
	end

	def maybe_promote
	end
end