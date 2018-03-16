#!/bin/bash
#
# Script to compile and test cs361 projects
#
#Alan Schexnayder, 03/16/18, V2.0


## CHANGE mapper TO YOUR EXECUTABLE NAME ##

executable_name=mapper


#color variables
RED='\033[1;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Building..."
make                                               #compiles

test () {
	echo -e "${WHITE}Begin testing with $1 input:${NC}"
	echo "Deleting your old queues..."
	touch /dev/mqueue/blank #to give the next line something to delete
	rm /dev/mqueue/*                                   #clears any queues
	rm -rf map classification actual/$1/*  #deletes any previously generated files
	./$executable_name inputs/$1                    #runs project using $1 input


	##
	## lines below here test classification using the $1 input

	#creates a hexdump of the generated classification file
	hexdump -Cv classification > actual/$1/classification_hexdump.txt

	#compares the difference between the hexdumps and sends them to a diff file
	diff actual/$1/classification_hexdump.txt expected/$1/expected_classification_hexdump.txt > actual/$1/classification_hexdump.diff

	if [ -s actual/$1/classification_hexdump.diff ]; #if file isn't empty
	then
		EXPECTEDSIZE=$(wc -c <"expected/$1/expected_classification_hexdump.txt") #calculate size of the diff file
	  DIFFSIZE=$(wc -c <"actual/$1/classification_hexdump.diff")
		echo -e "${RED}Classification file is wrong; these are the first few lines of the diff:${NC}"
		head -5 actual/$1/classification_hexdump.diff

		WRONGLINES=$(grep \< -o actual/$1/classification_hexdump.diff | wc -l)
		TOTALLINES=$(wc -l < expected/$1/expected_classification_hexdump.txt)
		RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

		PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
		PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

	echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"
	else
		echo -e "${GREEN}Classification works with $1!${NC}"

	fi

	## End classification testing


	## Begin map testing


	#creates a hexdump of the generated map file
	hexdump -Cv map > actual/$1/map_hexdump.txt

	#compares the difference between the hexdumps and sends them to a diff file
	diff actual/$1/map_hexdump.txt expected/$1/expected_map_hexdump.txt > actual/$1/map_hexdump.diff
	if [ -s actual/$1/map_hexdump.diff ]; #if file isn't empty
	then
		EXPECTEDSIZE=$(wc -c <"expected/$1/expected_map_hexdump.txt") #calculate size of the diff file
	  DIFFSIZE=$(wc -c <"actual/$1/map_hexdump.diff")
		echo -e "${RED}Map file is wrong; these are the first few lines of the diff:${NC}"
		head -5 actual/$1/map_hexdump.diff

		WRONGLINES=$(grep \< -o actual/$1/map_hexdump.diff | wc -l)
		TOTALLINES=$(wc -l < expected/$1/expected_map_hexdump.txt)
		RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

		PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
		PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

	echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"


	else
		echo -e "${GREEN}Map works with $1!${NC}"

	fi


	# end map testing

}



test sample_clusters
test alternating
test multi_jpg
