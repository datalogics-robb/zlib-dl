#!/bin/env python

#======================================================================
# Replace existing substrings in a Visual Studio project with new ones
#
# Receives 3 command line parameters:
# 	1) Name of project file
#	2) The substrings to be replaced and given as a comma separated
#	   string in square brackets
#	3) The substrings to replace those above and as a comma separated
#      string in square brackets
#
# Example: python myproject.vcxproj ["HIS_DEF","N/A","HIS_ITEM"] ["MY_DEF","NOP","MY_ITEM"]
#
# LeoK 11/19/2017
#======================================================================

import sys
import fileinput
import string

def do_help():
	# Print help information
	print("Usage: \n\t python replace_def.py <file_name> [<old_items>] [<new_items>],\n");
	print("Note: olddef and newdef are the compaund string containing comma separated string item in square brackets.")
	print("		 The number of items in olddef and newdef should be the same.")

def do_replace(filename,olddef,newdef):
	# Convert comma separated strings to lists
	olddef = olddef[1:len(olddef)-1]
	oldlist = [x.strip() for x in olddef.split(',')]
	newdef = newdef[1:len(newdef)-1]
	newlist = [x.strip() for x in newdef.split(',')]

	# Both lists should be the same length
	if len(oldlist) != len(newlist):
		do_help()
	else:
		Indexes = range(len(oldlist)); # List of item indexes
		for line in fileinput.input(filename, inplace=1):
			for i in Indexes:
				if string.find(line,oldlist[i]) != -1:
					line = line.replace(oldlist[i],newlist[i])
			print(line.rstrip())

if __name__ == '__main__':
	if len(sys.argv) > 3:    
		do_replace(sys.argv[1],sys.argv[2],sys.argv[3])
	else:
		do_help();

