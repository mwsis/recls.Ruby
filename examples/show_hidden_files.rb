#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'recls'

# To find only hidden files, need to:
#
# 1. Ensure that they are returned in search, by including Recls::SHOW_HIDDEN
# 2. Filter returned entries by hidden? attribute
Recls.file_rsearch('.', Recls::WILDCARDS_ALL, Recls::FILES | Recls::SHOW_HIDDEN).each do |fe|

  puts fe if fe.hidden?
end

