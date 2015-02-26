class Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@king = false
	end

	def king?
		@king
	end

	def show
		symbol = (king? ? 'K ' : 'P ')
		symbol.colorize(color)
	end
end