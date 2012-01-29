class Segment
  require 'colorize'
  
  attr_accessor :neighbors, :ancestry, :position, :children
  
  @@dict = File.new("/usr/share/dict/words").readlines.each {|i| i.chomp!}
#  @@dict = %w[car cry crypt cat cart]
  @@board = [%w[c a t a ], %w[a r t c], %w[r c y t], %w[w a r p]]
#  @@board = [%w[a b c d ], %w[e f g h], %w[i j k l], %w[m n o p]]
  @@words = []
  #0    c a t a
  #1    a r t c
  #2    r c y t
  #3    w a r p
  
  def initialize(position, ancestry)
    @position = position
    @ancestry = ancestry
    @neighbors = []
    @children = []
  end
  
  # If it fails both tests nothing happens, we run to the end and parent spawns another.
  
  def valid_length?
    @ancestry.count >= 3
  end
  
  def update_ancestry
    @ancestry << @position
  end
  
  def is_a_word?
    dict_copy = @@dict.clone
    dict_copy.keep_if {|i| /\A#{make_string}\z/.match(i)}
    puts "Checking wordness..."
    puts "We had " + "#{@@words.count}".red + " words..."
    @@words << dict_copy[0]
    puts "Is_a_word? self is: #{self.object_id}"
    puts "And it's the string: #{make_string}"
    puts "Now we have " + "#{@@words.count}".red
    puts "It's a word: #{dict_copy.first}".green
    puts "Is_a_word? Class: #{dict_copy[0].class}"
    return dict_copy[0].class == String
  end 
  
  def part_of_word?  
    dict_copy = @@dict.clone
    dict_copy.keep_if {|i| /\A#{make_string}\w+/.match(i)}
    puts "Part_of_word self is: #{self.object_id}"
    puts "And it's the string #{make_string}"
    puts "It's a part of: #{dict_copy.first}, and maybe others....".green
    puts "Part_of_word? Class: #{dict_copy[0].class}"
    return dict_copy[0].class == String
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
    @neighbors -= @ancestry
    return @neighbors
  end
  
  def make_string
    word = ""
    @ancestry.each do |i|
      word += @@board[i[0]][i[1]]
    end
    return word
  end
  
  def run
    update_ancestry
    puts "Updating ancestry... Ancestry is: #{print @ancestry.each {|i| i}}, self is: #{self.object_id}"
    puts "Running...".blue
    puts "Length is... #{@ancestry.count}".blue
    puts "Is length valid?... #{valid_length?}".blue
    find_neighbors
    if valid_length? && !part_of_word?
      puts "First run/if TRUE".red
      self.neighbors.clear
    elsif valid_length?
      is_a_word?
    else
      puts "Run else, spawning for each neighbor...".red
      until self.neighbors.empty?
        spawn
      end
    end
    puts "RUNNING CHILDREN... Children empty? #{@children.empty?}"
    @children.each do |i|
      puts "|i|.position is #{i.position}".green
      puts "Ancestry before running for #{i.object_id}: #{i.ancestry}".green
      i.run
      puts "Ancestry after running for #{i.object_id}: #{i.ancestry}".green
    end  
  end
    # until self.neighbors.empty?
    #   if valid_length?
    #     is_a_word?
    #     if part_of_word?
    #       spawn
    #     else
    #       self.neighbors.clear
    #     end
    #   else
    #     spawn
    #   end
    # end

  
  def spawn
    puts "Before spawning...  self is: #{self.object_id}Length: #{@ancestry.count}, Ancestry before addition: (#{@ancestry[0]}, #{@ancestry[1]}),  Words: #{@@words.count}".blue
    new_position = self.neighbors.pop
    new_ancestry = self.ancestry
    puts "Spawning a bew position: #{new_position}".blue
    @children << Segment.new(@neighbors.pop, @ancestry)
    puts "After spawning...  self is: #{self.object_id}Length: #{@ancestry.count}, Ancestry before addition: (#{@ancestry[0]}, #{@ancestry[1]}),  Words: #{@@words.count}".blue
  end
end

# seg = Segment.new([0,0], [])
# puts "Original object id: #{seg.object_id}"
# seg.run

#Segments need to be able to create segments
#Segments need to be able to remove 
