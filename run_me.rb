require_relative 'lib/board'
require_relative 'lib/branch'
require_relative 'lib/segment'

DICT = File.new("/usr/share/dict/words").readlines.each { |n| n.chomp! }

board = Board.new(ARGV[0], ARGV[1])
