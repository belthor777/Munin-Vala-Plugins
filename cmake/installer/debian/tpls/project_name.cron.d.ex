#
# Regular cron jobs for the oscam-svn package
#
0 4	* * *	root	[ -x /usr/bin/munin-vala-plugins_maintenance ] && /usr/bin/munin-vala-plugins_maintenance
