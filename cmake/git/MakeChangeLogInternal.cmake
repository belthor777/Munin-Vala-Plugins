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

# MakeChangeLogInternal.cmake -- Does the dirty work of getting the ChangeLog.

message (STATUS "Getting ChangeLog from repository")
exec_program ("/usr/bin/git"
              ARGS "log"
              OUTPUT_VARIABLE git_out
              RETURN_VALUE git_retval)
if (NOT "${git_retval}" STREQUAL 0)
  message (ERROR "Unable to generate ChangeLog from repository")
else ()
  set (output /home/thomas/Dokumente/github/munin-vala-plugins/build/ChangeLog)
  file (WRITE ${output} ${git_out})
  message (STATUS "Getting ChangeLog from repository - done")
endif ()

