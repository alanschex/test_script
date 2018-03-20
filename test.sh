#!/bin/bash
# Script to compile and test cs361 projects
# Alan Schexnayder, 03/20/18, V2.0

## change "mapper" to whatever your executable name is, i.e.  ##
## for PA5 it would be, mapper-with-queues                    ##
EXECUTABLE=mapper

# color variables
RED='\033[1;31m'
LIGHTYELLOW='\033[0;33m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
NC='\033[0m'           # No color

echo "Building..."
make                   #compiles

# $1 is the file input (sample_clusters, alternating, etc)
test () {
	echo -e "${WHITE}Beginning testing with $1 input...${NC}"
	echo "Deleting your old queues..."
	touch /dev/mqueue/blank                # gives the next line something to delete
	rm /dev/mqueue/*                       # clears any queues
	rm -rf map classification actual/$1/*  # deletes any previously generated files
	./$EXECUTABLE inputs/$1                # runs project using input passed in as the first argument

	generate_diffs $1 classification       # generates the diffs for the classification file
	generate_diffs $1 map                  # generates the diffs for the map file
}

generate_diffs() {
	# $1 refers to the input file
	# $2 refers to the map/classifcation file
	# creates a hexdump of the generated map or classifcation file
	hexdump -Cv $2 > actual/$1/$2_hexdump.txt

	# compares the difference between the hexdumps and sends them to a diff file
	diff actual/$1/$2_hexdump.txt expected/$1/expected_$2_hexdump.txt > actual/$1/$2_hexdump.diff
	if [ -s actual/$1/$2_hexdump.diff ]; # if file isn't empty
	then
		EXPECTEDSIZE=$(wc -c <"expected/$1/expected_$2_hexdump.txt") # calculate size of the expected file
	  DIFFSIZE=$(wc -c <"actual/$1/$2_hexdump.diff")               # calculate size of the diff file
		echo -e "${RED}$2 file is wrong:${NC}"
		DIFFLINES=$(head -5 actual/$1/$2_hexdump.diff)               # prints out the first few lines of the diff
		 echo -e "${LIGHTYELLOW}$DIFFLINES${NC}"

		WRONGLINES=$(grep \< -o actual/$1/$2_hexdump.diff | wc -l)
		TOTALLINES=$(wc -l < expected/$1/expected_$2_hexdump.txt)
		RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

		PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)      # calculates a percentage
		PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')       # Rounds to 1 decimal difference

	echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"

	else
		echo -e "${GREEN}$2 works with $1!${NC}"
	fi
}
test sample_clusters  # runs with "sample_clusters" inpput
test alternating      # runs with "alternating" inpput
test multi_jpg        # runs with "multi_jpg" inpput
