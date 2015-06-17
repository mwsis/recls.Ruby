# ######################################################################### #
# File:         recls/util.rb
#
# Purpose:      Utility module functions for recls library
#
# Created:      17th February 2014
# Updated:      18th June 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


require 'recls/ximpl/util'
require 'recls/internal/common'
require 'recls/internal/version'
require 'recls/ximpl/os'

module Recls

	# Obtains the absolute form of the given path
	def self.absolute_path(path)

		return Recls::Ximpl::absolute_path path
	end

	# Canonicalises the given path, by removing dots ('.' and '..')
	# directories
	def self.canonicalise_path(path)

		return Recls::Ximpl::canonicalise_path path
	end

	# Derives a given path relative to an origin, unless the path is
	# absolute
	def self.derive_relative_path(origin, path)

		return Recls::Ximpl::derive_relative_path origin, path
	end
end

# ############################## end of file ############################# #

