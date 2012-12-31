require_relative 'branch'
require 'colorize'

class Board

  attr_accessor :alphabet

  def initialize(board_size)
    @board_size = size.to_i
    @score = 0
    @words = []
    @grid = {}
    @alphabet = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    populate
    score
  end

  private

  def populate
    @board_size.times { |n| @board_size.times { |o| @grid[[n,o]]= @alphabet.sample } }
  end

  def score
    @grid.each_key do |n|
      branch = Branch.new(n, @grid, @board_size)
      puts "Creating branch #{n}"
      until branch.out_of_neighbors?
        if !branch.current_segment.added?
          if branch.is_a_word?
            @words << branch.add_word
            puts @words.green
            @score +=1
            puts 'Words:' + "#{@words.count}".green
            branch.current_segment.added = true
          end
        end
        if branch.can_grow? && branch.should_grow?
          branch.grow
          #puts ""
          #puts "..."
        else
          branch.retreat
          #puts ""
          #puts "..."
        end
      end
    end
  end
end