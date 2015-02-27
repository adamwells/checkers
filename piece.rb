require 'byebug'
require 'colorize'

class InvalidMoveError < ArgumentError; end

class Piece
  attr_reader :color
  attr_accessor :board, :position

  def initialize(color, position = nil, board = nil, king = false)
    @color = color
    @board = board
    @king = king
    @position = position
  end

  def king?
    @king
  end

  def check_king
    if color == :green && position[0] == 7
      @king = true
    elsif color != :green && position[0] == 0
      @king = true
    end
  end

  def show
    symbol = (king? ? 'K ' : 'P ')
    symbol.colorize(color)
  end

  def perform_slide(current_pos, next_pos)
    return false unless (current_pos[0] - next_pos[0]).abs == 1

    if possible_moves(current_pos).include?(next_pos) && @board[next_pos].nil?
      board.move(current_pos, next_pos)
      return true
    end
    false
  end

  def perform_jump(current_pos, next_pos)
    spot_between = [(current_pos[0] + next_pos[0]) / 2, (current_pos[1] + next_pos[1]) / 2]
    return false unless (current_pos[0] - next_pos[0]).abs == 2

    if possible_moves(current_pos).include?(next_pos) && @board[next_pos].nil?
      unless @board[spot_between].nil? || @board[spot_between].color == color
        @board.move(current_pos, next_pos)
        @board[spot_between] = nil
        return true
      end
    end
    false
  end

  def perform_moves!(sequence)
    if sequence.length == 2 && (sequence[0][0] - sequence[1][0]).abs == 1
      successful_move = perform_slide(sequence[0], sequence[1])
    else
      (0..sequence.length-2).each do |i|
        successful_move = perform_jump(sequence[i], sequence[i + 1])
        unless successful_move
          return false
        end
      end
    end
    successful_move
  end

  def perform_moves(sequence)
    if valid_move_sequence?(sequence)
      perform_moves!(sequence)
    else
      raise InvalidMoveError.new('Invalid Sequence')
    end
    check_king
  end

  def valid_move_sequence?(sequence)
    duped_board = board.dup
    duped_board[position].perform_moves!(sequence)
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
    if king?
      return [[1, -1], [1, 1], [-1, -1], [-1, 1]]
    elsif color == :green
      [[1, -1], [1, 1]]
    else
      [[-1, -1], [-1, 1]]
    end
  end
end