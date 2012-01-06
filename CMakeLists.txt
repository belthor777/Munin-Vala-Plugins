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
set ( CONFIG_PREFIX "/usr" )
set ( CONFIG_LICENSE "GPLv3")
set ( CONFIG_CPACK "DEB" )
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
# Add installer package options (e.g. debian folder)
################################################################################
option(BUILD_INSTALLER "Generate an Installer for your OS" OFF)
if ( BUILD_INSTALLER )
	add_subdirectory(cmake/installer)
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

	configure_file(${CMAKE_SOURCE_DIR}/cmake/Doxyfile.in ${PROJECT_BINARY_DIR}/Doxyfile  @ONLY IMMEDIATE)
	add_custom_target(Doc ALL
		COMMAND ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/Doxyfile
		SOURCES ${PROJECT_BINARY_DIR}/Doxyfile
		COMMENT "Generating API documentation with Doxygen" VERBATIM
	)
endif(BUILD_DOCUMENTATION)


################################################################################
# Add uninstall option
################################################################################
configure_file(
	"${CMAKE_SOURCE_DIR}/cmake/CMake_Uninstall.cmake.in"
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
if ( BUILD_INSTALLER )
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
message( "  AUTHOR = ${AUTHOR}" )
message( "  EMAIL = ${EMAIL}" )
message( "  BUILD_TYPE = ${BUILD_TYPE}" )
message( "  BUILD_INSTALLER = ${BUILD_INSTALLER}" )
message( "  CONFIG_PREFIX = ${CONFIG_PREFIX}" )
message( "  CONFIG_LICENSE = ${CONFIG_LICENSE}" )
message( "  CONFIG_CPACK = ${CONFIG_CPACK}" )
message( "  CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}" )
message( "  CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}" )
message( "" )
message( "Libs:" )
message( "" )
