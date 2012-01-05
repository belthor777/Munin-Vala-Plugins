# - Try to find libosso 
#
#  LIBOSSO_FOUND              True if libosso got found
#  LIBOSSO_INCLUDE_DIRS       Location of libosso headers 
#  LIBOSSO_LIBRARIES          List of libaries to use libosso
#  LIBOSSO_DEFINITIONS        Definitions to compile libosso 
#
#  Copyright (c) 2008 Florian Boor <florian@linuxtogo.org>
#
#  Redistribution and use is allowed according to the terms of the New
#  BSD license.
#  For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

INCLUDE( FindPkgConfig )
# Take care about libosso.pc settings
IF ( Libosso_FIND_REQUIRED )
  SET( _pkgconfig_REQUIRED "REQUIRED" )
ELSE ( Libosso_FIND_REQUIRED )
  SET( _pkgconfig_REQUIRED "" )
ENDIF ( Libosso_FIND_REQUIRED )

pkg_search_module( LIBOSSO ${_pkgconfig_REQUIRED} libosso )


# Look for libosso include dir and libraries w/o pkgconfig
IF ( NOT LIBOSSO_FOUND AND NOT PKG_CONFIG_FOUND )
	FIND_PATH( _libosso_include_DIR libosso.h 
		PATHS
		/opt/local/include/
		/sw/include/
		/usr/local/include/
		/usr/include/
	)
	FIND_LIBRARY( _libosso_link_DIR libosso 
		PATHS
		/opt/local/lib
		/sw/lib
		/usr/lib
		/usr/local/lib
		/usr/lib64
		/usr/local/lib64
		/opt/lib64
	)
	IF ( _libosso_include_DIR AND _libosso_link_DIR )
		SET ( _libosso_FOUND TRUE )
	ENDIF ( _libosso_include_DIR AND _libosso_link_DIR )


	IF ( _libosso_FOUND )
		SET ( LIBOSSO_INCLUDE_DIRS ${_libosso_include_DIR} )
		SET ( LIBOSSO_LIBRARIES ${_libosso_link_DIR} )
	ENDIF ( _libosso_FOUND )

	# Report results
	IF ( LIBOSSO_LIBRARIES AND LIBOSSO_INCLUDE_DIRS AND _libosso_FOUND )	
		SET( LIBOSSO_FOUND 1 )
		IF ( NOT Libosso_FIND_QUIETLY )
			MESSAGE( STATUS "Found libosso: ${LIBOSSO_LIBRARIES} ${LIBOSSO_INCLUDE_DIRS}" )
		ENDIF ( NOT Libosso_FIND_QUIETLY )
	ELSE ( LIBOSSO_LIBRARIES AND LIBOSSO_INCLUDE_DIRS AND _libosso_FOUND )	
		IF ( Libosso_FIND_REQUIRED )
			MESSAGE( SEND_ERROR "Could NOT find libosso" )
		ELSE ( Libosso_FIND_REQUIRED )
			IF ( NOT Libosso_FIND_QUIETLY )
				MESSAGE( STATUS "Could NOT find libosso" )	
			ENDIF ( NOT Libosso_FIND_QUIETLY )
		ENDIF ( Libosso_FIND_REQUIRED )
	ENDIF ( LIBOSSO_LIBRARIES AND LIBOSSO_INCLUDE_DIRS AND _libosso_FOUND )	

ENDIF ( NOT LIBOSSO_FOUND AND NOT PKG_CONFIG_FOUND )

# Hide advanced variables from CMake GUIs
MARK_AS_ADVANCED( LIBOSSO_LIBRARIES LIBOSSO_INCLUDE_DIRS )

