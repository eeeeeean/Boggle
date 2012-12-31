class Segment
  attr_accessor :neighbors, :position, :added, :word_part

  def initialize(position)
    @position = position
    @neighbors = []
    @added = false
    @word_part = true
    populate_neighbors
  end

  def populate_neighbors
    row = @position[0]
    column = @position[1]
    north = [row - 1, column]
    south = [row + 1, column]
    east = [row, column + 1]
    west = [row, column - 1]
    northwest = [row - 1, column - 1]
    southwest = [row + 1, column - 1]
    northeast = [row - 1, column + 1]
    southeast = [row + 1, column + 1]
    @neighbors << north << south << east << west << northwest << southwest << northeast << southeast
    @neighbors.keep_if {|i| i[0] >= 0 && i[0] <= 3 && i[1] >= 0 && i[1] <= 3}
  end

  def added?
    @added
  end

  def has_neighbor?
    !@neighbors.empty?
  end

end


