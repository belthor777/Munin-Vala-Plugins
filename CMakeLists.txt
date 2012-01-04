# CMake command examples:
# Native (Linux):
# cmake ..
# Windows:
# cmake -DCMAKE_TOOLCHAIN_FILE=~/cmake/Toolchain-mingw32.cmake -DCMAKE_INSTALL_PREFIX=~/cmake/win32 ..
# ARM (Linux):
# cmake -DCMAKE_TOOLCHAIN_FILE=~/cmake/Toolchain-codesourcery.cmake -DCMAKE_INSTALL_PREFIX=~/cmake/arm ..
cmake_minimum_required(VERSION 2.8)

project("munin-vala-plugins" C)

# configure
set ( CONFIG_CPACK 0 )
set ( CONFIG_PREFIX "/usr" )

# project version
set ( ${PROJECT_NAME}_MAJOR_VERSION 0 )
set ( ${PROJECT_NAME}_MINOR_VERSION 1 )
set ( ${PROJECT_NAME}_PATCH_LEVEL 0 )

# Set default install prefix to project root directory
if ( CMAKE_INSTALL_PREFIX STREQUAL "/usr/local" )
	set ( CMAKE_INSTALL_PREFIX "${CONFIG_PREFIX}" )
endif()


# Location where cmake first looks for modules.
list(APPEND CMAKE_MODULE_PATH
	${CMAKE_SOURCE_DIR}/cmake/vala
)


################################################################
# Find Vala
################################################################
include(ValaVersion)
include(ValaPrecompile)

find_package(Vala)
ensure_vala_version("0.10.0" MINIMUM)


################################################################
# Configure and find libraries
################################################################
if(NOT CMAKE_CROSSCOMPILING)

	find_package(PkgConfig)
	pkg_check_modules(GLIB REQUIRED glib-2.0)
	pkg_check_modules(GOBJECT REQUIRED gobject-2.0)

else(NOT CMAKE_CROSSCOMPILING)

	if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
		# GLIB include directories
		set(GLIB_CFLAGS
			-I${CMAKE_INSTALL_PREFIX}/include/glib-2.0
			-I${CMAKE_INSTALL_PREFIX}/lib/glib-2.0/include
		)

		# same as native values
		set(GLIB_LIBRARIES glib-2.0 gobject-2.0)

		# directory which includes *.dll.a files
		set(GLIB_LIBRARY_DIRS ${CMAKE_INSTALL_PREFIX}/lib)

	endif()

endif(NOT CMAKE_CROSSCOMPILING)


################################################################
# Dependencies
################################################################
if( DEFINED ${PROJECT_NAME}_DEPENDS OR DEFINED BUILD_WITH OR DEFINED LINK_WITH )
	# load macro
	if( NOT EXISTS "${CMAKE_MODULE_PATH}/MacroCheckDeps.cmake" )
		MESSAGE( FATAL_ERROR "\nMissing MacroCheckDeps.cmake...\n")
	endif()
	include( "${CMAKE_MODULE_PATH}/MacroCheckDeps.cmake" )
	CHECK_DEPS()
endif()


# Definitions
set(CFLAGS
	${GLIB_CFLAGS}
	${GOBJECT_CFLAGS}
)
add_definitions( ${CFLAGS} )

# Linker libraries
set(LIBS
	${GLIB_LIBRARIES}
	${GOBJECT_LIBRARIES}
)
link_libraries(${LIBS})

# Linker library directories
set(LIB_PATHS
	${GLIB_LIBRARY_DIRS}
)
link_directories(${LIB_PATHS})

# Include directories
set(INCLUDE_PATHS
	${PROJECT_SOURCE_DIR}/src
	${PROJECT_SOURCE_DIR}/src/plugins
)
include_directories(${INCLUDE_PATHS})


################################################################
# Add install options
################################################################
add_subdirectory(src)


################################################################
# Add debian package options
################################################################
if ( $(CONFIG_CPACK) )
	set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
	set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING")
	set (CPACK_PACKAGE_VERSION_MAJOR ${${PROJECT_NAME}_MAJOR_VERSION} )
	set (CPACK_PACKAGE_VERSION_MINOR ${${PROJECT_NAME}_MINOR_VERSION} )
	set (CPACK_PACKAGE_VERSION_PATCH ${${PROJECT_NAME}_PATCH_LEVEL} )
	set (CPACK_PACKAGE_INSTALL_DIRECTORY "aten${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}")
	set (CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
	set (CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CS_OSTYPE}")

	# Created by
	set (CPACK_DEBIAN_PACKAGE_MAINTAINER "Thomas Ludwig")
	set (CPACK_PACKAGE_CONTACT "moonmaker@gmx.de")

	# Packages
	set (CPACK_GENERATOR "TGZ;TBZ2;RPM;DEB")
	set (CPACK_CMAKE_GENERATOR ${CMAKE_GENERATOR})
	set (CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/linux_install/preinst;${CMAKE_CURRENT_SOURCE_DIR}/linux_install/postinst;${CMAKE_CURRENT_SOURCE_DIR}/linux_install/postrm;${CMAKE_CURRENT_SOURCE_DIR}/linux_install/config;${CMAKE_CURRENT_SOURCE_DIR}/linux_install/templates;${CMAKE_CURRENT_SOURCE_DIR}/linux_install/prerm")

	# Now use CPack
	include (CPack)
endif()

################################################################
# Add a target to generate API documentation with Doxygen
################################################################
# 
find_package(Doxygen)
if(DOXYGEN_FOUND)
	configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
	add_custom_target(doc
		${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM
	)
endif(DOXYGEN_FOUND)


################################################################
# Add uninstall option
################################################################
configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/CMake_Uninstall.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/CMake_Uninstall.cmake"
	IMMEDIATE @ONLY)

add_custom_target(uninstall
	COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/CMake_Uninstall.cmake)


################################################################
# Summary
################################################################
message( "" )
message( "Summary:" )
message( "  EXECUTABLE_OUTPUT_PATH = ${EXECUTABLE_OUTPUT_PATH}" )
message( "  VALA_EXECUTABLE = ${VALA_EXECUTABLE}" )
message( "Variables that can be changed:" )
message( "  CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}" )
message( "Libs:" )
message( "" )

################################################################
# CMAKE export settings
################################################################
EXPORT_LIBRARY_DEPENDENCIES( "${PROJECT_NAME}LibDeps.cmake" )
