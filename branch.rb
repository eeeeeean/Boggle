class Branch
  require 'colorize'
  attr_accessor :current_segment, :history, :words
  
  @@dict = File.new("/usr/share/dict/words").readlines.each {|i| i.chomp!}
  @@board = [%w[c a t a ], %w[a r t c], %w[r c y t], %w[w a r p]]
# c a t a
# a r t c
# r c y t
# w a r p
  
  def initialize(location)
    @location = location
    @history = [Segment.new(location)]
    @words = []
    @count = 0
  end

  def current_segment
    @history.last
  end
  
  def all_positions
    @history.collect {|i| i.position}
  end
  
  def print_board
      @@board.each do |i|
        puts "#{i.each {|j| print j}}"
      end
  end
  
  def grow
    new_segment = Segment.new(current_segment.neighbors.first)
    current_segment.neighbors -= [current_segment.neighbors.first]
    @history.push(new_segment)
    @history.each {|i| current_segment.neighbors -= [i.position]}
    @count += 1
    puts "Growth #: ".green + "#{@count}" 
    puts "Branch length is: ".green + "#{@history.count}"
    puts "Words collected: ".green + "#{@words}".red
    puts "..."
  end
  
  def retreat
    @history.delete_at(-1)
  end
  
  def can_grow?
    current_segment.has_neighbor?
  end
  
  def should_grow?
    make_string.length < 3 || part_of_word?
  end
  
  def next_neighbor?
    current_segment.neighbors.first
  end

  def make_string
    @history.map {|i| @@board[i.position[0]][i.position[1]]}.join
  end

  def part_of_word?
    @@dict.any? {|i| i.include?(make_string)}  
#    !@@dict.clone.keep_if {|i| /\A#{make_string}\w+/.match(i)}.empty?
  end
  
  def is_a_word?    
    @@dict.find {|i| i == make_string} unless make_string.length < 3
#    !@@dict.clone.keep_if {|i| /\A#{make_string}\z/.match(i)}.empty? && make_string.length > 2
  end
  
  def add_word
    @words << make_string
  end
  
end

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

branch = Branch.new([0,0])
until !branch.history.first.has_neighbor?
  if !branch.current_segment.added?
    if branch.is_a_word?
      branch.add_word
      branch.current_segment.added = true
    end
  end
  if branch.can_grow? && branch.should_grow?
    branch.grow
    puts ""
    puts "..."
  else
    branch.retreat
    puts ""
    puts "..."
  end
end  