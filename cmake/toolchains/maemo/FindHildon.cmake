# - Try to find Hildon libraries
#
#  LIBHILDON_FOUND              True if Hildon got found
#  LIBHILDON_INCLUDE_DIR         Location of Hildon headers 
#  LIBHILDON_LIBRARIES          List of libaries to use Hildon
#  LIBHILDON_DEFINITIONS        Definitions to compile Hildon 
#
#  Copyright (c) 2007 Daniel Gollub <dgollub@suse.de>
#  Copyright (c) 2008 Daniel Friedrich <daniel.friedrich@opensync.org>
#  Copyright (c) 2008 Florian Boor <florian@linuxtogo.org>
#
#  Redistribution and use is allowed according to the terms of the New
#  BSD license.
#  For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

IF ( NOT WIN32 )
	INCLUDE( UsePkgConfig )
	PKGCONFIG( hildon-1 _hildon_include_DIR _hildon_link_DIR _hildon_link_FLAGS _hildon_cflags )
ENDIF ( NOT WIN32 )


# Look for Hildon include dir and libraries, and take care about pkg-config first...
FIND_PATH( HILDON_INCLUDE_DIR hildon/hildon.h PATH_SUFFIXES hildon-1 PATHS ${_hildon_include_DIR} NO_DEFAULT_PATH )
#MESSAGE( STATUS "FINDLIBGLADEDIR: ${LIBGLADE_INCLUDE_DIR}" )
FIND_PATH( HILDON_INCLUDE_DIR hildon/hildon.h PATH_SUFFIXES hildon-1)
#MESSAGE( STATUS "FINDLIBGLADEDIR: ${LIBGLADE_INCLUDE_DIR}" )

FIND_LIBRARY( HILDON_LIBRARIES hildon-1 PATHS ${_hildon_link_DIR} NO_DEFAULT_PATH )
#MESSAGE( STATUS "FINDLIBGLADE: ${LIBGLADE_LIBRARIES}" )
FIND_LIBRARY( HILDON_LIBRARIES hildon-1 )
#MESSAGE( STATUS "FINDLIBGLADE: ${LIBGLADE_LIBRARIES}" )

# Report results
IF ( HILDON_LIBRARIES AND HILDON_INCLUDE_DIR )	
	SET( HILDON_FOUND 1 )
	IF ( NOT HILDON_FIND_QUIETLY )
		MESSAGE( STATUS "Found HILDON: ${HILDON_LIBRARIES}" )
	ENDIF ( NOT HILDON_FIND_QUIETLY )
ELSE ( HILDON_LIBRARIES AND HILDON_INCLUDE_DIR )	
	IF ( HILDON_FIND_REQUIRED )
		MESSAGE( SEND_ERROR "Could NOT find Hildon" )
	ELSE ( HILDON_FIND_REQUIRED )
		IF ( NOT HILDON_FIND_QUIETLY )
			MESSAGE( STATUS "Could NOT find Hildon" )	
		ENDIF ( NOT HILDON_FIND_QUIETLY )
	ENDIF ( HILDON_FIND_REQUIRED )
ENDIF ( HILDON_LIBRARIES AND HILDON_INCLUDE_DIR )	

# Hide advanced variables from CMake GUIs
MARK_AS_ADVANCED( HILDON_LIBRARIES HILDON_INCLUDE_DIR )
