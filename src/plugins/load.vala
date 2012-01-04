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

/* Show Shell Arguments */
public void show_cmd_args (string[] args ) {

	// Output the number of arguments
	stdout.printf ("%d command line argument(s):\n", args.length);

	// Enumerate all command line arguments
	foreach (string arg in args) {
		println (arg);
	}
}

/* Main */
int main_test (string[] args) {

	//show_cmd_args ( args );

	switch ( args[1] ) {
		case "config":
			println ("graph_title Load average");
			println ("graph_vlabel load");
			println ("load.label load");
			return 0;
		break;
	}

	/* Get Load */
	try {
	
		string cmd = "cut -d' ' -f2  /proc/loadavg";
		string standard_output, standard_error;
		int exit_status;

		// Non-blocking
		//Process.spawn_command_line_async (cmd);

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

