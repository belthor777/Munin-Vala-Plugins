# CMake command examples:
# Native (Linux):
# cmake ..
# Windows:
# cmake -DCMAKE_TOOLCHAIN_FILE=~/cmake/Toolchain-mingw32.cmake -DCMAKE_INSTALL_PREFIX=~/cmake/win32 ..
# ARM (Linux):
# cmake -DCMAKE_TOOLCHAIN_FILE=~/cmake/Toolchain-codesourcery.cmake -DCMAKE_INSTALL_PREFIX=~/cmake/arm ..

project("munin-vala-plugins" C)

cmake_minimum_required(VERSION 2.6)

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
message( "Libs:" )
message( "" )


