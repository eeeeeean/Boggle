class Segment

  attr_accessor :liberties, :position
  attr_reader :dict

  def initialize(position, board_size, dict)
    @position = position
    @board_size = board_size - 1
    @liberties = []
    @dict = dict
    @dict.freeze
    populate_liberties
  end

  def populate_liberties
    row = @position[0]
    column = @position[1]
    n = [row - 1, column]
    s = [row + 1, column]
    e = [row, column + 1]
    w = [row, column - 1]
    nw = [row - 1, column - 1]
    sw = [row + 1, column - 1]
    ne = [row - 1, column + 1]
    se = [row + 1, column + 1]
    @liberties << n << s << e << w << nw << sw << ne << se
    @liberties.keep_if {|i| within_bounds?(i) }
  end

  def within_bounds?(pos) #a single [0,1] type array
    pos[0] >= 0 && pos[0] <= @board_size && pos[1] >= 0 && pos[1] <= @board_size
  end

  def has_liberty?
    @liberties.compact!
    !@liberties.empty?
  end
end


