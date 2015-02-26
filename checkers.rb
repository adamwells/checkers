require_relative 'board'

b = Board.new

p = Piece.new(:green)
p2 = Piece.new(:yellow)

b.place_piece([2, 1], p)
b.place_piece([3, 2], p2)
b.render
p p.possible_moves(p.position)

p.perform_jump([2, 1], [4, 3])
b.render
p p.possible_moves(p.position)