require_relative 'branch'
require 'colorize'

class Board

  attr_accessor :alphabet

  def initialize(board_size, string = nil)
    @board_size = board_size.to_i
    @string = string ? string.split(',') : nil
    @words = []
    @grid = {}
    @alphabet = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    populate
    score
    print_words
  end

  private

  def get_letters
    @string ? @string.shift : @alphabet.sample
  end

  def populate
    @board_size.times do |n|
      @board_size.times { |o| @grid[[n,o]]= get_letters }
    end
  end

  def show_grid
    count = []
    @board_size.times { |n| count << n }
    count.each do |n|
      count.each { |o| print " #{@grid[[n,o]]}" }
      print "\n"
    end
  end

  def score
    show_grid
    @grid.each_key do |n|
      branch = Branch.new(n, @grid, @board_size)
      puts "Creating branch #{n}".green
      until branch.dead?
        @words << branch.stringify if branch.is_a_word?
        if branch.can_grow? && branch.should_grow?
          branch.grow
        else
          branch.retreat
          # The branch is dying by removing neighbors.
        end
      end
      puts "Total score: #{@words.uniq.count}"
    end
  end

  def print_words
    print @words.uniq
  end
end