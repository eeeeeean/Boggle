class Segment
  attr_accessor :neighbors, :position, :added, :word_part

  def initialize(position, board_size)
    @position = position
    @board_size = board_size
    @neighbors = []
    @added = false
    @word_part = true
    populate_neighbors
  end

  def populate_neighbors
    row = @position[0]
    column = @position[1]
    n = [row - 1, column]
    s = [row + 1, column]
    e = [row, column + 1]
    w = [row, column - 1]
    nw = [row - 1, column - 1]
    se = [row + 1, column - 1]
    ne = [row - 1, column + 1]
    se = [row + 1, column + 1]
    @neighbors << n << s << e << w << nw << sw << ne << se
    @neighbors.keep_if {|i| within_bounds?(i) }
  end

  def within_bounds?(pos) #a single [0,1] type array
    pos[0] >= 0 && pos[0] <= @board_size && pos[1] >= 0 && pos[1] <= @board_size
  end

  def added?
    @added
  end

  def has_neighbor?
    !@neighbors.empty?
  end

end


