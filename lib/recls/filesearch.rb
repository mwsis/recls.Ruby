# ######################################################################### #
# File:         recls/filesearch.rb
#
# Purpose:      Defines the Recls::FileSearch class for the recls.ruby library.
#
# Created:      24th July 2012
# Updated:      22nd June 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


require 'recls/internal/common'
require 'recls/internal/version'
require 'recls/entry'
require 'recls/flags'
require 'recls/ximpl/os'

module Recls

	class FileSearch

		include Enumerable

		def initialize(search_root, patterns, flags)

			if not search_root
				search_root = '.'
			else
				search_root = search_root.to_s
			end
			search_root = '.' if search_root.empty?
			search_root = File.expand_path(search_root) if '~' == search_root[0]

			case	patterns
			when	NilClass
				patterns = []
			when	String
				patterns = patterns.split(/[|#{Recls::Ximpl::OS::PATH_SEPARATOR}]/)
			when	Array
			else
				patterns = patterns.to_a
			end

			patterns = [ Recls::WILDCARDS_ALL ] if patterns.empty?

			if(0 == (Recls::TYPEMASK & flags))
				flags |= Recls::FILES
			end

			# now de-dup the patterns, to avoid duplicates in search
			patterns	=	patterns.flatten
			patterns	=	patterns.uniq

			@search_root	=	search_root
			@patterns	=	patterns
			@flags		=	flags
		end

		attr_reader :search_root
		attr_reader :patterns
		attr_reader :flags

		def each(&blk)

			search_root = @search_root
			search_root = Recls::Ximpl::absolute_path search_root

			search_root = search_root.gsub(/\\/, '/') if Recls::Ximpl::OS::OS_IS_WINDOWS

			# set the (type part of the) flags to zero if we want
			# everything, to facilitate later optimisation

			flags = @flags

			if(Recls::Ximpl::OS::OS_IS_WINDOWS)
				mask = (Recls::FILES | Recls::DIRECTORIES)
			else
				mask = (Recls::FILES | Recls::DIRECTORIES | Recls::LINKS | Recls::DEVICES)
			end

			if(mask == (mask & flags))
				flags = flags & ~Recls::TYPEMASK
			end

			patterns = @patterns

			patterns = patterns.map do |pattern|

				pattern = pattern.gsub(/\./, '\\.')
				pattern = pattern.gsub(/\?/, '.')
				pattern = pattern.gsub(/\*/, '.*')
				pattern
			end

			FileSearch::search_directory_(search_root, search_root, patterns, flags, &blk)
		end

		private
		def FileSearch::is_dots(name)

			case	name
			when	'.', '..'
				true
			else
				false
			end
		end

		def FileSearch::stat_or_nil_(path, flags)

			begin
				Recls::Ximpl::FileStat.stat path
			rescue Errno::ENOENT => x
				nil
			rescue SystemCallError => x
				# TODO this should be filtered up and/or logged

				if(0 != (STOP_ON_ACCESS_FAILURE & flags))
					raise
				end

				nil
			end
		end

		# searches all entries - files, directories, links, devices
		# - that match the given (patterns) in the given directory
		# (dir) according to the given (flags), invoking the given
		# block (blk). The search directory (search_root) is passed in
		# order to allow calculation of search_relative_path in the
		# entry.

		def FileSearch::search_directory_(search_root, dir, patterns, flags, &blk)

			# array of FileStat instances
			entries = []

			patterns.each do |pattern|

				Recls::Ximpl::dir_entries_maybe(dir, flags).each do |name|

					next if is_dots(name)

					if not name =~ /^#{pattern}$/
						next
					end

					entry_path = File::join(dir, name)

					fs = stat_or_nil_(entry_path, flags)

					entries << fs
				end
			end

			# array of FileStat instances
			subdirectories = []

			Recls::Ximpl::dir_entries_maybe(dir, flags).each do |subdir|

				next if is_dots(subdir)

				subdir_path = File::join(dir, subdir)

				fs = stat_or_nil_(subdir_path, flags)

				next if not fs

				next unless fs.directory?

				subdirectories << fs
			end


			# now filter the file-stat instances and send each
			# remaining to the block in Entry instance
			entries.each do |fs|

				next if not fs

				if(0 == (Recls::SHOW_HIDDEN & flags))
					if fs.hidden?
						next
					end
				end

				match	=	false

				match	||=	(0 != (Recls::FILES & flags) && fs.file?)
				match	||=	(0 != (Recls::DIRECTORIES & flags) && fs.directory?)
				match	||=	(0 != (Recls::DEVICES & flags) && fs.blockdev?)

				next unless match

				blk.call Recls::Entry.new(fs.path, fs, search_root)
			end

			# sub-directories

			return unless (0 != (Recls::RECURSIVE & flags))

			subdirectories.each do |fs|

				if(0 == (Recls::SHOW_HIDDEN & flags))
					if fs.hidden?
						next
					end
				end

				if(0 == (Recls::SEARCH_THROUGH_LINKS & flags))
					if File.symlink? fs.path
						next
					end
				end

				FileSearch::search_directory_(search_root, fs.path, patterns, flags, &blk)
			end
		end
	end
end

# ############################## end of file ############################# #

