# ######################################################################### #
# File:         recls/foreach.rb
#
# Purpose:      Definition of Recls::foreach() utility function
#
# Created:      22nd October 2014
# Updated:      18th June 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


require 'recls/filesearch'

module Recls

	private
	class FileSearchLineEnumerator

		include Enumerable

		def initialize(fs)

			@fs = fs
		end

		def each(&block)

			@fs.each do |fe|

				IO::readlines(fe).each_with_index do |line, index|

					case	block.arity
					when	1
						yield line
					when	2
						yield line, index
					when	3
						yield line, index, fe
					else
						raise ArgumentError, "block must take 1, 2, or 3 parameters - #{block.arity} given. (Perhaps you have applied each_with_index, which cannot be done to Recls.foreach)"
					end
				end
			end
		end
	end
	public

	def self.foreach(*args, &block)

		fs = nil

		case	args.length
		when	1
			raise ArgumentError "Single argument must be of type #{Recls::FileSearch}" unless args[0].kind_of? Recls::FileSearch

			fs = args[0]
		when	3
			fs = Recls::FileSearch.new(args[0], args[1], args[2])
		else
			raise ArgumentError "Function requires single argument (#{Recls::FileSearch}) or three arguments (directory, patterns, flags)"
		end

		if block_given?

			FileSearchLineEnumerator.new(fs).each(block)

			return nil
		else

			return FileSearchLineEnumerator.new(fs)
		end
	end
end

# ############################## end of file ############################# #
