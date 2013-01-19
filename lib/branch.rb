  class String
    def first_letter_is?(letter)
      self.match(/\A#{letter}\w*/i )
    end

    def first_part_is?(string)
      self.match(/\A#{string}\w*/i )
    end
  end

class Branch
  require 'colorize'
  attr_accessor :stack

  def initialize(location, grid, board_size)
    @grid = grid
    @location = location
    @board_size = board_size
    @dict = fresh_dict
    @stack = [Segment.new(location, board_size, @dict)]
    add_stack_to_head
  end

  def dead?
    no_stack?
  end

  # A liberty is a position, known to the active segment, where branch can grow

  def grow
    new_segment = activate_liberty
    current_segment.liberties -= [first_liberty]
    make_new_head(new_segment)
    add_stack_to_head
    add_head_to_stack
  end

  def retreat
    @stack.delete_at(-1)
  end

  def can_grow?
    current_segment.has_liberty?
  end

  def should_grow?
    stringify.length < 3 || part_of_word?
  end

  def stringify
    make_string @stack
  end

  def is_a_word?
    get_dict.find { |i| i == stringify } unless too_short?
  end

  private

  def activate_liberty # liberties are positions
    string = stringify + "#{ @grid[first_liberty] }"
    new_dict = check_dict(current_segment.dict, string)
    Segment.new(first_liberty, @board_size, new_dict)
  end

  def add_head_to_stack
    @stack.each { |i| i.liberties -= current_segment.position }
  end

  def add_stack_to_head
    @stack.each { |i| current_segment.liberties -= [i.position] }
  end

  def check_dict(dict, string)
    dict.dup.keep_if { |n| n.first_part_is?(string) }
  end

  def current_segment
    @stack.last
  end

  def first_liberty
    current_segment.liberties.first
  end

  def fresh_dict
    letter = @grid[@location]
    dict = File.new("/usr/share/dict/words")
    dict.readlines.keep_if { |n| n.first_letter_is?(letter) }.each {|i| i.chomp!}
  end

  def get_dict
    current_segment.dict
  end

  def make_new_head(segment)
    @stack.push(segment)
  end

  def make_string(array_of_segments)
    array_of_segments.map do |i|
      point = [i.position[0].to_i, i.position[1].to_i]
      @grid[point]
    end.join
  end

  def no_stack?
    @stack.empty?
  end

  def out_of_liberties?
    @stack.first.liberties.empty?
  end

  def part_of_word?
    get_dict.compact.length > 0
  end

  def too_short?
    stringif.length < 3
  end
end
