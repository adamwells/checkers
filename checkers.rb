require_relative 'board'

class Checkers
	attr_accessor :board

	def initialize
		@board = Board.new
		@board.setup_board
	end

	def play
		until board.over?
			system('clear')
			board.render
			sequence = get_move_sequence
			board.make_move_sequence(sequence)
		end
	end

	def get_move_sequence
		sequence = []
		puts 'What is the position of the piece you\'d like to move?'
		sequence << gets.chomp.split(',')

		puts 'Enter first/next move position (\'q\' to exit).'
		until sequence.last == ['q']
			sequence << gets.chomp.split(',')
			p sequence
		end
		sequence.pop
		sequence.map do |el|
			el.map { |num| num.to_i }
		end
	end
end

c = Checkers.new
c.play