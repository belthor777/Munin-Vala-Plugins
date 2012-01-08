/var/log/munin/*.log {
    rotate 12
    weekly
    compress
    missingok
    postrotate
	/etc/init.d/munin-vala-plugins reload > /dev/null
     endscript
}
