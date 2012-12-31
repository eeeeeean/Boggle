  class String
    def first_letter_is(letter)
      self.match(/\A#{letter}\w+/i )
    end

    def first_part_is(string)
      self.match(/\A#{string}\w+/i )
    end
  end

class Branch
  require 'colorize'
  attr_accessor :current_segment, :history, :words, :count

  def initialize(location, grid, board_size)
    @grid = grid
    @location = location
    @history = [Segment.new(location, board_size)]
    @words = []
    @count = 0
    @dict = make_dict
  end

  def make_dict
    letter = @grid[@location]
    dict = File.new("/usr/share/dict/words")
    dict.readlines.keep_if { |n| n.first_letter_is(letter) }.each {|i| i.chomp!}
  end

  def current_segment
    @history.last
  end

  def all_positions
    @history.collect {|i| i.position}
  end

  def grow
    new_segment = Segment.new(current_segment.neighbors.first)
    current_segment.neighbors -= [current_segment.neighbors.first]
    @history.push(new_segment)
    @history.each {|i| current_segment.neighbors -= [i.position]}
    @count += 1
    #puts "Growth #: ".green + "#{@count}"
    #puts "Branch length is: ".green + "#{@history.count}"
    #puts "Words collected: ".green + "#{@words}".red
    #puts "..."
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

  def out_of_neighbors?
    !@history.first.has_neighbor?
  end

  def make_string
    @history.map do |i|
      point = [i.position[0].to_i, i.position[1].to_i]
      @grid[point]
    end.join

  end

  def part_of_word?
    check_dict
    @dict.empty?
  end

  def check_dict
    @dict.keep_if { |n| n.first_part_is(make_string) }
  end

  def is_a_word?
    @dict.find {|i| i == make_string} unless make_string.length < 3
  end

  def add_word
    make_string
  end
end
