#!/bin/bash
#
# Script to compile and test cs361 projects
#
#Alan Schexnayder, 03/08/18, V1.0
make                                #compiles
rm -rf map classification actual/sample_clusters/*  #deletes any previously generated files
./mapper inputs/sample_clusters            #runs project using sample_clusters input


##
## lines below here test classification
##

#creates a hexdump of the generated classification file
hexdump -C classification > actual/sample_clusters/actual_classification_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/sample_clusters/actual_classification_hexdump.txt expected/sample_clusters/expected_classification_hexdump.txt > actual/sample_clusters/classification_hexdump.diff

if [ -s actual/sample_clusters/classification_hexdump.diff ]; #if file isn't empty
then
	echo "Classification file is wrong; these are the first few lines of the diff:"
	head -8 actual/sample_clusters/classification_hexdump.diff
	echo "...and so on and so on" # sniffles zizekily
else 
	echo "Classification works!"
fi
##
## lines below here test map
##

#creates a hexdump of the generated map file
hexdump -C map > actual/sample_clusters/map_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/sample_clusters/map_hexdump.txt expected/sample_clusters/expected_map_hexdump.txt > actual/sample_clusters/map_hexdump.diff
if [ -s actual/sample_clusters/map_hexdump.diff ]; #if file isn't empty
then
	echo "Map file is wrong; these are the first few lines of the diff:"
	head -8 actual/sample_clusters/map_hexdump.diff
	echo "...and so on and so on" # sniffles zizekily
else 
	echo "Map works!"
	
fi

#
# end sample_clusters testing
#