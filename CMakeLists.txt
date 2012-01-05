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
set ( AUTHOR "Thomas Ludwig" )
set ( EMAIL "<moonmaker@gmx.de>")
set ( BUILD_TYPE "Debug" )
set ( BUILD_INSTALLER ON )
set( CONFIG_PREFIX "/usr" )
option( CONFIG_CPACK "Configure Installer Package (DEB/RPM)" "DEB" )

# project version
set ( ${PROJECT_NAME}_MAJOR_VERSION 0 )
set ( ${PROJECT_NAME}_MINOR_VERSION 1 )
set ( ${PROJECT_NAME}_PATCH_LEVEL 0 )
set ( PROJECT_VERSION "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}.${${PROJECT_NAME}_PATCH_LEVEL}" )

# Enable debug symbols by default
if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE Debug)
endif()

# Set default install prefix to project root directory
set ( CMAKE_INSTALL_PREFIX "${CONFIG_PREFIX}" )

# Location where cmake first looks for modules.
list(APPEND CMAKE_MODULE_PATH
	${CMAKE_SOURCE_DIR}/cmake/vala
)


################################################################################
# VALA - Find
################################################################################
include(ValaVersion)
include(ValaPrecompile)

find_package(Vala)
ensure_vala_version("0.10.0" MINIMUM)


################################################################################
# CROSSCOMPILING - Use CMakeLists.txt
################################################################################
#add_subdirectory(cmake/toolchains)


################################################################################
# VALA - Configure and find libraries
################################################################################
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


################################################################################
# Dependencies
################################################################################

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


################################################################################
# Add install options
################################################################################
add_subdirectory(src)


################################################################################
# Generate ChangeLog from GIT
################################################################################
#list(APPEND CMAKE_MODULE_PATH	${CMAKE_SOURCE_DIR}/cmake/git )
#include (MakeChangeLog)


################################################################################
# Add debian package options
################################################################################
option(BUILD_INSTALLER "Generate an Installer for your OS" OFF)
if ( BUILD_INSTALLER )
	message(STATUS "-> Building Installer" )
	set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README")
	set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "Plugins for Munin written in VALA")
	set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING")
	set (CPACK_PACKAGE_VERSION_MAJOR ${${PROJECT_NAME}_MAJOR_VERSION} )
	set (CPACK_PACKAGE_VERSION_MINOR ${${PROJECT_NAME}_MINOR_VERSION} )
	set (CPACK_PACKAGE_VERSION_PATCH ${${PROJECT_NAME}_PATCH_LEVEL} )
	set (CPACK_PACKAGE_INSTALL_DIRECTORY "installer${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}")
	set (CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
	set (CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CS_OSTYPE}")
	set (CPACK_PACKAGE_SOURCE_Vcs_GIT "git://github.com/MoonMaker/Munin-Vala-Plugins" )
	set (CPACK_PACKAGE_SOURCE_Vcs_BRZ "lp:~moonmaker/munin/trunk" )
	set (CPACK_PACKAGE_SOURCE_Vcs_BROWSER "http://bazaar.launchpad.net/~moonmaker/munin/trunk/files" )

	# what to put in the archive
	set (CPACK_STRIP_FILES TRUE)
	set (CPACK_COMPONENTS_ALL bin)			# config doc

	# Created by
	set (CPACK_PACKAGE_CONTACT "${AUTHOR} ${EMAIL}")

	# Debian Ubuntu
	if ( CONFIG_CPACK STREQUAL "DEB")

		message(STATUS "   Building Debian Package" )

		# Add Create Debian Module
		list(APPEND CMAKE_MODULE_PATH	"${CMAKE_SOURCE_DIR}/cmake/distribution/deb")

		set (CPACK_DEBIAN_PACKAGE_NAME "${PROJECT_NAME}")
		set (CPACK_DEBIAN_PACKAGE_MAINTAINER "${CPACK_PACKAGE_CONTACT}")
		set (CPACK_GENERATOR "DEB")
		set (CPACK_DEBIAN_PACKAGE_ARCHITECTURE "any" )
		set (CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://ludwig.im" )
		set (CPACK_DEBIAN_PACKAGE_BUILD_DEPENDS "debhelper (>= 7.0)"
												"cmake (>= 2.4)"
												"cdbs (>= 0.4.41)"
												"valac (>= 0.10)"
												"doxygen, graphviz" )
		set (CPACK_DEBIAN_PACKAGE_DEPENDS "munin-node")
		set (CPACK_DEBIAN_PACKAGE_PRIORITY "optional" )
		set (CPACK_DEBIAN_PACKAGE_SECTION "net")
		set (CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/preinst;
												${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/postinst;
												${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/postrm;
												${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/config;
												${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/templates;
												${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/prerm")

		# Now use CPack
		include (CPack)
		include (CreateDEB)

	# Red Hat
	elseif ( CONFIG_CPACK STREQUAL "RPM" )
		message(STATUS "   Building Red Hat Package" )
		set (CPACK_GENERATOR "RPM")
	else()
		message(STATUS "   Building TGZ Package" )
		set (CPACK_GENERATOR "TGZ")
	endif()

	# Installer
	set (CPACK_CMAKE_GENERATOR "${CMAKE_GENERATOR}")

endif()


################################################################################
# Doxygen - Add a target to generate API documentation
################################################################################
option(BUILD_DOCUMENTATION "Use Doxygen to create the HTML based API documentation" OFF)
if ( BUILD_DOCUMENTATION )
	find_package(Doxygen)
	if (NOT DOXYGEN_FOUND)
		message(FATAL_ERROR "Doxygen is needed to build the documentation. Please install it correctly")
	endif()

	configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in ${PROJECT_BINARY_DIR}/Doxyfile  @ONLY IMMEDIATE)
	add_custom_target(Doc ALL
		COMMAND ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/Doxyfile
		SOURCES ${PROJECT_BINARY_DIR}/Doxyfile
		#${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		#WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM
	)
endif(BUILD_DOCUMENTATION)


################################################################################
# Add uninstall option
################################################################################
configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/CMake_Uninstall.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/CMake_Uninstall.cmake" IMMEDIATE @ONLY)

add_custom_target(uninstall
	COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/CMake_Uninstall.cmake
	COMMENT "Add uninstall options"
)


################################################################################
# Summary
################################################################################
message( "" )
message( "Environment:" )
message( "  HOST_GNU_TYPE = ${HOST_GNU_TYPE}" )
message( "  HOST_ARCH = ${HOST_ARCH}" )
message( "  BUILD_GNU_TYPE = ${BUILD_GNU_TYPE}" )
message( "  BUILD_ARCH = ${BUILD_ARCH}" )
message( "  Operating System: ${OperatingSystem}")
message( "  Architecture: ${CS_OS_ARCH}" )
message( "  System Type: ${CS_OSTYPE}")
message( "  System: ${CS_OS_SYS}")
message( "  CPU: ${CS_OS_CPU}")
message( "  HW: ${CS_OS_HW}")
message( "" )
if ( CREATE_INSTALLER )
message( "Installer:" )
message( "  GENERATOR = ${CPACK_GENERATOR}" )
message( "  INSTALL_DIRECTORY = ${CPACK_PACKAGE_INSTALL_DIRECTORY}" )
message( "" )
endif()
message( "Summary:" )
message( "  PACKAGE_VERSION = ${PROJECT_VERSION}" )
message( "  EXECUTABLE_OUTPUT_PATH = ${EXECUTABLE_OUTPUT_PATH}" )
message( "  VALA_EXECUTABLE = ${VALA_EXECUTABLE}" )
message( "" )
message( "Variables that can be changed:" )
message( "  CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}" )
message( "  CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}" )
message( "" )
message( "Libs:" )
message( "" )
