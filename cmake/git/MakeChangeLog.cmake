# Humm and Strumm Video Game
# Copyright (C) 2008-2011, the people listed in the AUTHORS file. 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# MakeChangeLog.cmake -- Defines the changelog target that produces a ChangeLog
# file from the Git repository.

include (FindGit)
if ( GIT_FOUND )

	set( MakeChangelog_CMAKE_DIR "${CMAKE_SOURCE_DIR}/cmake/git" )
	configure_file ("${MakeChangelog_CMAKE_DIR}/MakeChangeLogInternal.cmake.in"
					"${MakeChangelog_CMAKE_DIR}/MakeChangeLogInternal.cmake" IMMEDIATE @ONLY)
	set_property (	DIRECTORY APPEND PROPERTY
					ADDITIONAL_MAKE_CLEAN_FILES ${MakeChangelog_CMAKE_DIR}/MakeChangeLogInternal.cmake)

	add_custom_command (OUTPUT ${CMAKE_BINARY_DIR}/ChangeLog
						COMMAND "${CMAKE_COMMAND}" -P "${MakeChangelog_CMAKE_DIR}/MakeChangeLogInternal.cmake")
	set_property (	DIRECTORY APPEND PROPERTY
					ADDITIONAL_MAKE_CLEAN_FILES ${CMAKE_BINARY_DIR}/ChangeLog)

	# TARGET: changelog
	# Runs git log on the online repository and pipes the output to a file
	# ChangeLog.
	add_custom_target (changelog DEPENDS ${CMAKE_BINARY_DIR}/ChangeLog)
	
endif()
