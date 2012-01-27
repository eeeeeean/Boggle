class Segment
  
  @@dict = File.new("/usr/share/dict/words").readlines.each {|i| i.chomp!}
  @@board = [%w[c a t a ], %w[a r t c], %w[r c y t], %w[w a r p]]
  @@words = []
  #0    c a t a
  #1    a r t c
  #2    r c y t
  #3    w a r p

  attr_accessor :position, :neighbors, :ancestry
  
  def initialize(position, ancestry)
    @position = position
    @ancestry = ancestry
    @neighbors = []
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
  
  def update_ancestry
    @ancestry << @position
  end
  
  def make_string
    word = ""
    @ancestry.each do |i|
      word += @@board[i[0]][i[1]]
    end
    return word
  end
  
  def is_a_word?
    if make_string.length > 1
      @@dict.each do |i|
        if /#{make_string}\z/.match(i)
          @@words << i
          return true
        end
      end
    else
      return false
    end
  end 
  
  def part_of_word?
    if make_string.length > 1
      @@dict.each do |i|
        if /#{make_string}/.match(i)
          return true
        end
      end
    else
      return false
    end
  end 
end

seg = Segment.new([0,1], [[0,0]])
seg.update_ancestry
#Are you a word? ####################### 1)


puts "..."
puts "1) Is seg a word? #{seg.is_a_word?}"

puts "..."

#Are you part of a word? ################ 2)
puts "2) Is seg part of a word? #{seg.part_of_word?}" 

puts "..."

#Do you have neighbors? ################# 3)
puts "3) Does seg have neighbors #{seg.find_neighbors}"
puts "..."
puts "4) Here is seg's position #{seg.position}"
puts "4.5) Here is seg's ancestry: #{seg.ancestry}"

seg2 = Segment.new(seg.neighbors.first, seg.ancestry)
#Are you a word? ####################### 1)
seg2.update_ancestry
puts "1) Is seg2 a word? #{seg2.is_a_word?}"

puts "..."

#Are you part of a word? ################ 2)
puts "2) Is seg2 part of a word? #{seg2.part_of_word?}"
puts "2.5) Seg2 is: #{seg2.make_string}"
puts "2.75 Seg2's ancestry is: #{seg2.ancestry}"
puts "..."

#Do you have neighbors? ################# 3)
puts "3) Does seg2 have neighbors #{seg2.find_neighbors}"
puts "..."
puts "4) Here is seg2's position #{seg2.position}"
# board.each do |i|
#   row_been = []
#   i.each do |j|
#     array_been = []
#     if dict.includes?(j)
#       solution << j
#     elsif !dict.keep_if {|k| k =~ /\A[j]\w+/ }.empty?
#       array_been << j.index
#       rown_been << array_been
#     end
#   end
# end
# 
# def right_neighbor
#   neighbor = square_array[@position[row]][@position[column] + 1]
#   if neighbor
#     return ["#{row}", "#{column + 1}"]
#   end
# end
# 
# def left_neighbor    
#   neighbor = square_array[@position[row]][@position[column] - 1]
#   if neighbor
#     return ["#{row}", "#{column - 1}"]
#   end
#     
# def top_neighbor
#   neighbor = square_array[@position[row - 1]][@position[column]]
#   if neighbor
#     return ["#{row - 1}", "#{column}"]
#   end
# end
# 
# def bottom_neighbor
#   neighbor = square_array[@position[row + 1]][@position[column]]
#   if neighbor
#     return ["#{row + 1}", "#{column + count}"]
#   end
# end
