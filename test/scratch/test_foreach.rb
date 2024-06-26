#! /usr/bin/ruby
#
# test Recls search methods

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'recls/foreach'

puts
puts "with given block:"
count_1 = 0
Recls.foreach(Recls::FileSearch.new(nil, '*.rb', Recls::RECURSIVE)).each do |line, line_number, fe|

  line        = line.chomp
  line_number = 1 + line_number

  puts "#{fe.search_relative_path}(#{line_number + 1}): #{line}"

  count_1 += 1
end

puts
puts "as returned enumerator:"
e = Recls.foreach(Recls::FileSearch.new(nil, '*.rb', Recls::RECURSIVE))
count_2 = 0
e.each do |line, line_number, fe|

  line        = line.chomp
  line_number = 1 + line_number

  puts "#{fe.search_relative_path}(#{line_number + 1}): #{line}"

  count_2 += 1
end


