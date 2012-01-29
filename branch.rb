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
  end

  def current_segment
    @history.last
  end
  
  def grow
    new_segment = Segment.new(current_segment.neighbors.first)
    @history.push(new_segment)
    puts "New segment is: #{new_segment.position}".green
    @history[-2].neighbors.delete_if {|i| i == current_segment.position}
    @history.each {|i| current_segment.neighbors -= i.position}
    puts "Its chain is: #{@history}".green
    puts puts "And these are the the neighbors for #{@history[-2].position}: #{@history[-2].neighbors}"
    puts "..."
  end
  
  def retreat
    @history.delete_at(-1)
  end
  
  def can_grow?
    @history.last.has_neighbor?
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
    !@@dict.clone.keep_if {|i| /\A#{make_string}\w+/.match(i)}.empty?
  end
  
  def is_a_word?    
    !@@dict.clone.keep_if {|i| /\A#{make_string}\z/.match(i)}.empty? && make_string.length > 2
  end
  
  def add_word
    @words << make_string unless !is_a_word?
  end
  
end

class Segment
  attr_accessor :neighbors, :position, :added
  
  def initialize(position)
    @position = position
    @neighbors = []
    @added = false
    find_neighbors
  end
  
  def find_neighbors
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
  puts "In the loop".blue
  if !branch.current_segment.added?
    if branch.is_a_word?
      branch.add_word
      branch.current_segment.added = true
      puts "#{branch.words}".red
    end
  end
  if branch.can_grow? && branch.should_grow?
    puts "Growing...from #{branch.current_segment.position}, word: #{branch.make_string}".green
    branch.grow
    puts "...to word #{branch.make_string}"
  else
    branch.retreat
  end
end  