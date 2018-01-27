# ######################################################################### #
# File:         recls/util.rb
#
# Purpose:      Utility module functions for recls library
#
# Created:      17th February 2014
# Updated:      25th January 2018
#
# Author:       Matthew Wilson
#
# Copyright (c) 2012-2018, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################### #


require 'recls/ximpl/util'
require 'recls/ximpl/os'

module Recls

	# Obtains the absolute form of the given path
	def self.absolute_path(path)

		return Recls::Ximpl.absolute_path path
	end

	# Canonicalises the given path, by removing dots ('.' and '..')
	# directories
	def self.canonicalise_path(path)

		return Recls::Ximpl.canonicalise_path path
	end

	# Derives a given path relative to an origin, unless the path is
	# absolute
	def self.derive_relative_path(origin, path)

		return Recls::Ximpl.derive_relative_path origin, path
	end

	# Combines paths, optionally canonicalising them
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +origin+:: [::String, ::Recls::Entry] The origin. May not be +nil+
	#     unless +path+ is not +nil+
	#   - +path+:: [::String, ::Recls::Entry] The path. May not be +nil+
	#     unless +origin+ is not +nil+
	#   - +options+:: [::Hash] Options that moderate the combination
	#
	# * *Parameters:*
	#   - +:canonicalise+:: [boolean] Causes the evaluated path to be
	#     canonicalised - with +Recls.canonicalise_path+ - before it is
	#     returned
	#   - +:clean+:: [boolean] Causes the evaluated path to be cleaned
	#     (i.e. sent to +cleanpath+) before it is returned. Ignored if
	#     +:canonicalise+ is specified
	#   - +:clean_path+:: [boolean] Equivalent to +:clean+, but deprecated
	#     and may be removed in a future version
	#
	# === Return
	#  The combined path
	def self.combine_paths(origin, path, options={})

		raise ArgumentError, 'origin and path cannot both be nil' if origin.nil? && path.nil?

		return path.to_s if origin.nil?
		return origin.to_s if path.nil?

		return Recls::Ximpl.combine_paths origin, path, options
	end
end

# ############################## end of file ############################# #


