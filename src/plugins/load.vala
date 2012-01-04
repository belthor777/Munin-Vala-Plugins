#!/usr/bin/env vala
/* load.vala
 *
 * Copyright (C) 2012  Thomas Ludwig
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 * 	Thomas Ludwig <moonmaker@gmx.de>
 */

/* Print to console */
public void println (string str) {
	stdout.printf ("%s\n", str);
}

/* Main */
int main_tmp (string[] args) 
{

	if ( args[1] == "autoconf" )
	{
		println ("yes");
		return 0;
	}

	if ( args[1] == "config" ) 
	{
		println ("graph_title Load average");
		println ("graph_args --base 1000 -l 0");
		println ("graph_vlabel load");
		println ("graph_scale no");
		println ("graph_category system");
		println ("load.label load");
		
		//print_warning load
		//print_critical load

		println ("graph_info The load average of the machine describes how many processes are in the run-queue (scheduled to run \"immediately\").");
		println ("load.info 5 minute load average");

		return 0;
	}

	/* Get Load */
	try {
	
		string cmd = "cut -d' ' -f2  /proc/loadavg";
		string standard_output, standard_error;
		int exit_status;

		// Blocking with output
		Process.spawn_command_line_sync (cmd,	out standard_output,
												out standard_error,
												out exit_status);
		if (exit_status == 0) 
		{
			stdout.printf ("load.value %s", standard_output);
		}

	} catch (SpawnError e) {
		stderr.printf ("%s\n", e.message);
	}

	return 0;
}

