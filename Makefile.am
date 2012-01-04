NULL = 

#Build in these directories:

SUBDIRS = \
	src \
	po \
	$(NULL)

munin_pluginsdocdir = ${prefix}/doc/munin_plugins
munin_pluginsdoc_DATA = \
	ChangeLog \
	README \
	COPYING \
	AUTHORS \
	INSTALL \
	NEWS\
	$(NULL)

EXTRA_DIST = \
	$(munin_pluginsdoc_DATA) \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in\
	$(NULL)

DISTCLEANFILES = \
	intltool-extract \
	intltool-merge \
	intltool-update \
	po/.intltool-merge-cache \
	$(NULL)

