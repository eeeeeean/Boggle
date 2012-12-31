require_relative 'branch'
require 'colorize'

class Board

  attr_accessor :alphabet

  def initialize(board_size)
    @board_size = board_size.to_i
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
      puts "Creating branch #{n}".green
      until branch.dead?
        @words << branch.make_string if branch.is_a_word?
        branch.can_grow? && branch.should_grow? ? branch.grow : branch.retreat
      end
      puts "Total score: #{@words.uniq.count}"
    end
  end
end