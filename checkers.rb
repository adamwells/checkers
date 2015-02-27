require_relative 'board'

class Checkers
  attr_accessor :board

  def initialize
    @board = Board.new
    @board.setup_board
    @turn = :yellow
  end

  def play
    until board.over?
      system('clear')
      board.render
      sequence = get_move_sequence

      raise ArgumentError.new('Cannot move pieces belonging to the other player!') if board[sequence[0]].color != @turn
      board.make_move_sequence(sequence)

      @turn = (@turn == :yellow ? :green : :yellow)
    end

  rescue InvalidMoveError => e
    puts e.message
    sleep(2)
    retry
  rescue ArgumentError => e
    puts e.message
    sleep(2)
    retry
  rescue InvalidMoveError => e
    puts "That move sequence doesn't work!"
    sleep(2)
    retry
  rescue => e
    puts "Something went wrong... Sorry!"
    sleep(2)
    retry
  end

  def parse!(sequence)
    sequence.pop
    sequence.map! do |el|
      el.map { |num| num.to_i }
    end

    sequence.map! { |el| [7 - el[0], el[1]]}
  end

  def get_move_sequence
    sequence = []
    puts "What is the position of the piece you'd like to move, #{@turn}? (<x>, <y> format)".colorize(@turn)
    sequence << gets.chomp.split(',').reverse

    puts "Enter first/next move position, #{@turn} ('q' to end sequence).".colorize(@turn)
    until sequence.last == ['q']
      sequence << gets.chomp.split(',').reverse
      p sequence
    end

    parse!(sequence)
  end
end

c = Checkers.new
c.play