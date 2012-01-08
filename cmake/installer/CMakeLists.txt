	message(STATUS "-> Building Installer" )
	set (CPACK_PACKAGE_LICENSE ${CONFIG_LICENSE})
	set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/README")
	set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "Plugins for Munin written in VALA")
	set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")
	set (CPACK_PACKAGE_VERSION_MAJOR ${${PROJECT_NAME}_MAJOR_VERSION} )
	set (CPACK_PACKAGE_VERSION_MINOR ${${PROJECT_NAME}_MINOR_VERSION} )
	set (CPACK_PACKAGE_VERSION_PATCH ${${PROJECT_NAME}_PATCH_LEVEL} )
	set (CPACK_PACKAGE_INSTALL_DIRECTORY "installer${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}")
	set (CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
	set (CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CS_OSTYPE}")
	set (CPACK_IGNORE_FILES "/CVS/;/\\.svn/;/\\.bzr/;/\\.hg/;/\\.git/;\\.swp$;\\.#;/#")
	set (CPACK_PACKAGE_SOURCE_Vcs_GIT "git://github.com/MoonMaker/Munin-Vala-Plugins" )
	set (CPACK_PACKAGE_SOURCE_Vcs_BZR "lp:~moonmaker/munin/trunk" )
	set (CPACK_PACKAGE_SOURCE_Vcs_BROWSER "http://bazaar.launchpad.net/~moonmaker/munin/trunk/files" )
	set (CPACK_PACKAGE_SPOURCE_DOWNLOADFROM ${CPACK_PACKAGE_SOURCE_Vcs_BROWSER})

	# what to put in the archive
	set (CPACK_STRIP_FILES TRUE)

	# Components - DOC and BIN
	set (CPACK_COMPONENTS_ALL doc)			# config doc

	# Created by
	set (CPACK_PACKAGE_CONTACT "${AUTHOR} ${EMAIL}")

	# Debian Ubuntu
	if ( CONFIG_CPACK STREQUAL "DEB")

		message(STATUS "   Building Debian Package" )

		# Add Create Debian Module
		set (CPACK_DEBIAN_INSTALLER_DIR "${CMAKE_SOURCE_DIR}/cmake/installer/debian")
		list(APPEND CMAKE_MODULE_PATH	"${CPACK_DEBIAN_INSTALLER_DIR}")

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

		# Now use CPack
		include (CPack)
		include (CreateDEB)

	# Red Hat
	elseif ( CONFIG_CPACK STREQUAL "RPM" )
		message(STATUS "   Building Red Hat Package" )
		set (CPACK_GENERATOR "RPM")
	else()
		message(STATUS "   Building TGZ Package" )
		set (CPACK_GENERATOR "TBZ2")
	endif()

	# Installer
	set (CPACK_CMAKE_GENERATOR "${CMAKE_GENERATOR}")
