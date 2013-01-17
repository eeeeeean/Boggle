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
    @dict = make_dict
    @history = [Segment.new(location, board_size, @dict)]
    @words = []
    @count = 0
    add_history_to_head
  end

  def dead?
    no_history?
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
    new_segment = activate_neighbor if first_neighbor
    current_segment.neighbors -= [first_neighbor]
    make_new_head(new_segment) if first_neighbor
    add_history_to_head
  end

  def activate_neighbor # neighbors are positions
    string = stringify + " #{ @grid[first_neighbor] }"
    new_dict = check_dict(current_segment.dict, string)
    Segment.new(first_neighbor, @board_size, new_dict)
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

  def get_dict
    current_segment.dict
  end

  def retreat
    @history.delete_at(-1)
  end

  def can_grow?
   # puts "Can grow for #{make_string} is: #{current_segment.has_neighbor?} "
   # puts "History members: #{@history.count} "
    current_segment.has_neighbor?
  end

  def should_grow?
    #puts "#Should grow for #{make_string} is: #{make_string.length < 3 || part_of_word?}"
    stringify.length < 3 || part_of_word?
  end

  def out_of_neighbors?
    @history.first.neighbors.empty?
  end

  def make_string(array_of_segments)
    array_of_segments.map do |i|
      point = [i.position[0].to_i, i.position[1].to_i]
      @grid[point]
    end.join
  end

  def stringify
    make_string @history
  end

  def part_of_word? #eliminate non-matches until empty
    check_dict(get_dict, stringify)
    !get_dict.empty?
  end

  def check_dict(dict, string)
    dict.keep_if { |n| n.first_part_is?(string) }
  end

  def is_a_word?
    get_dict.find { |i| i == stringify } unless stringify.length < 3
  end
end
