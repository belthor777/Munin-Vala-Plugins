################################################################
# Actually compile the executable
################################################################

# determine source and header files
#file(GLOB VALA_PLUGIN_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/plugins/*.vala)
#file(GLOB VALA_VAPIS ${CMAKE_CURRENT_SOURCE_DIR}/vapi/*.vapi)
#include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/plugins)
#list(REMOVE_ITEM VALA_PLUGIN_SRC "plugins/test.vala")

#foreach(i ${VALA_PLUGIN_SRC})
#	get_filename_component(out ${i} NAME)
#	list(APPEND VALA_SRCS_AUX plugins/${out})
#endforeach()

# Debug valac
if(ENABLE_DEBUG)
	set (VALA_OPTIONS ${VALA_OPTIONS} -D HAS_DEBUG)
endif()

set(VALA_PLUGIN_SRC
	plugins/load.vala
)

# use valac to compile sources to c files
vala_precompile(
	VALA_C
		${VALA_PLUGIN_SRC}
	OPTIONS
		--thread
		--debug
)


################################################################
# Install common files
################################################################
message( "  VALA_C = ${VALA_C}" )

# install plugins
add_executable ( load ${VALA_C} )
install (TARGETS 
			load
		DESTINATION 
			${CMAKE_INSTALL_PREFIX}/share/munin/plugins
)

# install credits
install(
	FILES
		${CMAKE_SOURCE_DIR}/README.md
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/doc/munin-vala-plugins
)

# install manpage
install(
	FILES
		${CMAKE_SOURCE_DIR}/resources/munin-vala-plugins.1
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/man/man1
)

################################################################
# Install Plugins
################################################################

# load
#file(GLOB LOAD_VALA "load.c")
#add_executable(vala_load "${CMAKE_SOURCE_DIR}/src/plugins/${LOAD_VALA}")
#install(
#	TARGETS
#		load
#	RUNTIME DESTINATION
#		${CMAKE_INSTALL_PREFIX}/share/munin/plugins
#)


