################################################################
# Actually compile the executable
################################################################

# determine source and header files
file(GLOB VALA_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala */*.vala)

# use valac to compile sources to c files
vala_precompile(VALA_C
		${VALA_SRC}
		${CMAKE_SOURCE_DIR}/src/main.vala
	PACKAGES
		${VALA_PKGS}
	OPTIONS
		--vapidir=${CMAKE_SOURCE_DIR}/vapi/
		--thread
	CUSTOM_VAPIS
	GENERATE_VAPI
	GENERATE_HEADER
)

# compile c-sources
add_executable(munin-vala-plugins ${VALA_C})

################################################################
# Install common files
################################################################

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
install(
	TARGETS
		load
	RUNTIME DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/munin/plugins
)


