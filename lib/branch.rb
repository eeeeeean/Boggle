  class String
    def first_letter_is?(letter)
      self.match(/\A#{letter}\w+/i )
    end

    def first_part_is?(string)
      self.match(/\A#{string}\w+/i )
    end
  end

class Branch
  require 'colorize'
  attr_accessor :current_segment, :history, :words, :count

  def initialize(location, grid, board_size)
    @grid = grid
    @location = location
    @board_size = board_size
    @history = [Segment.new(location, board_size)]
    @words = []
    @count = 0
    @dict = make_dict
  end

  def dead?
    out_of_neighbors? || no_history?
  end

  def no_history?
    @history.empty?
  end

  def make_dict
    letter = @grid[@location]
    dict = File.new("/usr/share/dict/words")
    dict.readlines.keep_if { |n| n.first_letter_is?(letter) }.each {|i| i.chomp!}
  end

  def current_segment
    @history.last
  end

  def all_positions
    @history.collect {|i| i.position}
  end

  def grow
    new_segment = activate_neighbor
    current_segment.neighbors -= [first_neighbor]
    make_new_head(new_segment)
    add_history_to_head
  end

  def activate_neighbor
    Segment.new(first_neighbor, @board_size)
  end

  def first_neighbor
    current_segment.neighbors.first
  end

  def make_new_head(segment)
    @history.push(segment)
  end

  def add_history_to_head
    @history.each {|i| current_segment.neighbors -= [i.position]}
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

  def out_of_neighbors?
    @history.first.neighbors.empty?
  end

  def make_string
    @history.map do |i|
      point = [i.position[0].to_i, i.position[1].to_i]
      @grid[point]
    end.join

  end

  def part_of_word? #eliminate non-matches until empty
    check_dict
    !@dict.empty?
  end

  def check_dict
    @dict.keep_if { |n| n.first_part_is?(make_string) }
  end

  def is_a_word?
    @dict.find {|i| i == make_string} unless make_string.length < 3
  end
end
