#!/bin/env python

#==================================================================
# Replace preprocessor definition in existing Visual Studio project
# 
# Receives 3 command lne parameters:
# 	1) Name of project file (must be in current directory)
#	2) Old preprocessor definition to be replaced
#	3) New preprocessor definituion replacimng the old one
#
# Example: python myproject.vcxproj HIS_DEF MY_DEF
# 		   After this change the project source files will be 
#		   compilied with /D MY_DEF instead of /D HIS_DEF 
# LeoK 11/12/2017
#==================================================================

import sys
import fileinput
import string

def do_remove(filename,olddef,newdef):
	print("All substrings \"%s\" will be replaced with \"%s\" in file %s" %(olddef,newdef,filename))
	for line in fileinput.input(filename, inplace=1):
		if string.find(line,olddef) != -1:
			line = line.replace(olddef,newdef)
		print(line.rstrip())

if __name__ == '__main__':
	if len(sys.argv) > 3:    
		do_remove(sys.argv[1],sys.argv[2],sys.argv[3])
	else:
		print("Usage: \n\t python replace_def.py <file_name> <olddef> <newdef>");

