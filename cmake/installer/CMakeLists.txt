	# Config Variables - From Config File
	# CONFIG_HOMEPAGE
	# CONFIG_DESCRIPTION_SUMMARY
	# CONFIG_AUTHOR
	# CONFIG_CONTACT_EMAIL

	# CPACK - Environment Variables
	message(STATUS "-> Building Installer" )
	set (CPACK_PACKAGE_LICENSE ${CONFIG_LICENSE})
	set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/README")
	set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "${CONFIG_DESCRIPTION_SUMMARY}")
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
	set (CPACK_PACKAGE_SOURCE_DOWNLOADFROM ${CPACK_PACKAGE_SOURCE_Vcs_BROWSER})

	# what to put in the archive
	set (CPACK_STRIP_FILES TRUE)

	# Components - DOC and BIN
	set (CPACK_COMPONENTS_ALL doc)			# config doc

	# Created by
	set (CPACK_PACKAGE_CONTACT "${CONFIG_AUTHOR} ${CONFIG_CONTACT_EMAIL}")

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
		set (CPACK_DEBIAN_PACKAGE_HOMEPAGE "${CONFIG_HOMEPAGE}" )
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

	# Windows and Mac - NSIS-Installer
	elseif ( CONFIG_CPACK STREQUAL "NSIS" )

		message(STATUS "   Building Windows Installer" )
		set (CPACK_GENERATOR "NSIS")
		set (CPACK_NSIS_PACKAGE_NAME "${PROJECT_NAME} ${CPACK_PACKAGE_VERSION}")
		set (CPACK_NSIS_MENU_LINKS "${CONFIG_HOMEPAGE}" "Homepage for ${PROJECT_NAME}")
		set (CPACK_NSIS_URL_INFO_ABOUT "${CONFIG_HOMEPAGE}")
		set (CPACK_NSIS_HELP_LINK "${CONFIG_HOMEPAGE}")

		set (CPACK_NSIS_MODIFY_PATH "OFF")
		set (CPACK_NSIS_MUI_ICON "${PROJECT_SOURCE_DIR}/cmake/nsis/lemon.ico")
		set (CPACK_NSIS_MUI_UNIICON "${PROJECT_SOURCE_DIR}/cmake/nsis/uninstall.ico")
		set (CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/cmake/nsis\\\\installer.bmp")
		set (CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\lemon.ico")
		set (CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} ${PROJECT_NAME}")
		set (CPACK_NSIS_CONTACT "${CONFIG_CONTACT_EMAIL}")
		set (CPACK_NSIS_CREATE_ICONS_EXTRA "
			CreateShortCut \\\"$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Documentation.lnk\\\" \\\"$INSTDIR\\\\share\\\\doc\\\\index.html\\\"
			WriteINIStr '\$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\Documenation.url' 'InternetShortcut' 'URL' '${CONFIG_HOMEPAGE}'")
		")
		set (CPACK_NSIS_DELETE_ICONS_EXTRA "
			!insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP
			Delete \\\"$SMPROGRAMS\\\\$MUI_TEMP\\\\Documentation.lnk\\\"
			RMDir '\$SMPROGRAMS\\\\$MUI_TEMP'"
		")

		# Components - Examples - 4 Components in this example
		set(CPACK_COMPONENTS_ALL docs applications libraries headers)

		# Components - Applications
		set(CPACK_COMPONENT_APPLICATIONS_DISPLAY_NAME "MyLib Application")
		set(CPACK_COMPONENT_APPLICATIONS_DESCRIPTION "An extremely useful application that makes use of MyLib")

		# Components - Documents
		set(CPACK_COMPONENT_DOCS_DISPLAY_NAME "Documents")
		set(CPACK_COMPONENT_DOCS_DESCRIPTION "Documents Descriptions")

		# Components - Libraries
		set(CPACK_COMPONENT_LIBRARIES_DISPLAY_NAME "Libraries")
		set(CPACK_COMPONENT_LIBRARIES_DESCRIPTION "Static libraries used to build programs with MyLib")

		# Components - C++ Headers
		set(CPACK_COMPONENT_HEADERS_DISPLAY_NAME "C Headers")
		set(CPACK_COMPONENT_HEADERS_DESCRIPTION "C/C++/Vala header files for use with MyLib")

		# Components - Grouping
		set(CPACK_COMPONENT_APPLICATIONS_GROUP "Runtime")
		set(CPACK_COMPONENT_DOCS_GROUP "Runtime Documentation")
		set(CPACK_COMPONENT_LIBRARIES_GROUP "Development")
		set(CPACK_COMPONENT_HEADERS_GROUP "Development")

		# Components - Grouping Description
		set(CPACK_COMPONENT_GROUP_RUNTIME_DESCRIPTION	"Runtime of ${PROJECT_NAME}")
		set(CPACK_COMPONENT_GROUP_DEVELOPMENT_DESCRIPTION	"Components needed to develop software using ${PROJECT_NAME}")
		set(CPACK_COMPONENT_GROUP_DOCUMENTATION_DESCRIPTION	"Documentation of ${PROJECT_NAME}")

		# Components - Installation Types FULL and Developer
		SET(CPACK_ALL_INSTALL_TYPES Full Developer)
		set(CPACK_COMPONENT_LIBRARIES_INSTALL_TYPES Developer Full)
		set(CPACK_COMPONENT_HEADERS_INSTALL_TYPES Developer Full)
		set(CPACK_COMPONENT_APPLICATIONS_INSTALL_TYPES Full)
		set(CPACK_COMPONENT_DOCS_INSTALL_TYPES Developer Full)

		# Icon in the add/remove control panel. Must be an .exe file 
		#set(CPACK_NSIS_INSTALLED_ICON_NAME bin\\\\${EXE_TARGET_NAME}.exe)

		# Now use CPack
		include (CPack)

	else()
		message(STATUS "   Building TGZ Package" )
		set (CPACK_GENERATOR "TBZ2")
	endif()

	# Installer
	set (CPACK_CMAKE_GENERATOR "${CMAKE_GENERATOR}")
