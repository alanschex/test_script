#!/bin/bash
#
# Script to compile and test cs361 projects
#
#Alan Schexnayder, 03/16/18, V2.0


#global variables

executable_name=mapper
RED='\033[1;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color



sample_clusters_input=inputs/sample_clusters
alternating_input=inputs/alternating
multi_jpg_input=inputs/multi_jpg

echo -e "${WHITE}Begin testing with sample_clusters input:${NC}"
echo



echo "Building..."
make                                               #compiles
echo "Deleting your old queues.."
rm /dev/mqueue/*                                   #clears any queues
rm -rf map classification actual/sample_clusters/* #deletes any previously generated files
./$executable_name $sample_clusters_input                    #runs project using sample_clusters input


##
## lines below here test classification using the sample_clusters input

#creates a hexdump of the generated classification file
hexdump -Cv classification > actual/sample_clusters/actual_classification_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/sample_clusters/actual_classification_hexdump.txt expected/sample_clusters/expected_classification_hexdump.txt > actual/sample_clusters/classification_hexdump.diff

if [ -s actual/sample_clusters/classification_hexdump.diff ]; #if file isn't empty
then
	EXPECTEDSIZE=$(wc -c <"expected/sample_clusters/expected_classification_hexdump.txt") #calculate size of the diff file
  DIFFSIZE=$(wc -c <"actual/sample_clusters/classification_hexdump.diff")
	echo -e "${RED}Classification file is wrong; these are the first few lines of the diff:${NC}"
	head -5 actual/sample_clusters/classification_hexdump.diff

	WRONGLINES=$(grep \< -o actual/sample_clusters/classification_hexdump.diff | wc -l)
	TOTALLINES=$(wc -l < expected/sample_clusters/expected_classification_hexdump.txt)
	RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

	PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
	PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"
else
	echo -e "${GREEN}Classification works with sample_clusters!${NC}"

fi

##End sample_clusters classification testing
##


##
## lines below here test map with sample_clusters


#creates a hexdump of the generated map file
hexdump -Cv map > actual/sample_clusters/map_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/sample_clusters/map_hexdump.txt expected/sample_clusters/expected_map_hexdump.txt > actual/sample_clusters/map_hexdump.diff
if [ -s actual/sample_clusters/map_hexdump.diff ]; #if file isn't empty
then
	EXPECTEDSIZE=$(wc -c <"expected/sample_clusters/expected_map_hexdump.txt") #calculate size of the diff file
  DIFFSIZE=$(wc -c <"actual/sample_clusters/map_hexdump.diff")
	echo -e "${RED}Map file is wrong; these are the first few lines of the diff:${NC}"
	head -5 actual/sample_clusters/map_hexdump.diff

	WRONGLINES=$(grep \< -o actual/sample_clusters/map_hexdump.diff | wc -l)
	TOTALLINES=$(wc -l < expected/sample_clusters/expected_map_hexdump.txt)
	RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

	PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
	PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"


else
	echo -e "${GREEN}Map works with sample_clusters!${NC}"

fi


# end map sample_clusters testing
#


#
## begin testing with alternating input
echo
echo -e "${WHITE}Begin testing with alternating input:${NC}"
echo


echo "Deleting your old queues.."
rm /dev/mqueue/*                                   #clears any queues
rm -rf map classification actual/alternating/* #deletes any previously generated files
./$executable_name $alternating_input                    #runs project using alternating input


##
## lines below here test classification using the alternating input

#creates a hexdump of the generated classification file
hexdump -Cv classification > actual/alternating/actual_classification_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/alternating/actual_classification_hexdump.txt expected/alternating/expected_classification_hexdump.txt > actual/alternating/classification_hexdump.diff

if [ -s actual/alternating/classification_hexdump.diff ]; #if file isn't empty
then
	EXPECTEDSIZE=$(wc -c <"expected/alternating/expected_classification_hexdump.txt") #calculate size of the diff file
  DIFFSIZE=$(wc -c <"actual/alternating/classification_hexdump.diff")
	echo -e "${RED}Classification file is wrong; these are the first few lines of the diff:${NC}"
	head -5 actual/alternating/classification_hexdump.diff

	WRONGLINES=$(grep \< -o actual/alternating/classification_hexdump.diff | wc -l)
	TOTALLINES=$(wc -l < expected/alternating/expected_classification_hexdump.txt)
	RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

	PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
	PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"
else
	echo -e "${GREEN}Classification works with alternating!${NC}"
fi

##End alternating classification testing
##


##
## lines below here test map with alternating



#creates a hexdump of the generated map file
hexdump -Cv map > actual/alternating/map_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/alternating/map_hexdump.txt expected/alternating/expected_map_hexdump.txt > actual/alternating/map_hexdump.diff
if [ -s actual/alternating/map_hexdump.diff ]; #if file isn't empty
then
	EXPECTEDSIZE=$(wc -c <"expected/alternating/expected_map_hexdump.txt") #calculate size of the diff file
  DIFFSIZE=$(wc -c <"actual/alternating/map_hexdump.diff")
	echo -e "${RED}Map file is wrong; these are the first few lines of the diff:${NC}"
	head -5 actual/alternating/map_hexdump.diff

	WRONGLINES=$(grep \< -o actual/alternating/map_hexdump.diff | wc -l)
	TOTALLINES=$(wc -l < expected/alternating/expected_map_hexdump.txt)
	RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

	PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
	PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"


else
	echo -e "${GREEN}Map works with alternating!${NC}"

fi


# end map alternating testing
#


#
## begin testing with multi_jpg input
echo
echo -e "${WHITE}Begin testing with multi_jpg input:${NC}"
echo


echo "Deleting your old queues.."
rm /dev/mqueue/*                                   #clears any queues
rm -rf map classification actual/multi_jpg/* #deletes any previously generated files
./$executable_name $multi_jpg_input                    #runs project using multi_jpg input


##
## lines below here test classification using the multi_jpg input

#creates a hexdump of the generated classification file
hexdump -Cv classification > actual/multi_jpg/actual_classification_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/multi_jpg/actual_classification_hexdump.txt expected/multi_jpg/expected_classification_hexdump.txt > actual/multi_jpg/classification_hexdump.diff

if [ -s actual/multi_jpg/classification_hexdump.diff ]; #if file isn't empty
then
	EXPECTEDSIZE=$(wc -c <"expected/multi_jpg/expected_classification_hexdump.txt") #calculate size of the diff file
  DIFFSIZE=$(wc -c <"actual/multi_jpg/classification_hexdump.diff")
	echo -e "${RED}Classification file is wrong; these are the first few lines of the diff:%${NC}"
	head -5 actual/multi_jpg/classification_hexdump.diff

	WRONGLINES=$(grep \< -o actual/multi_jpg/classification_hexdump.diff | wc -l)
	TOTALLINES=$(wc -l < expected/multi_jpg/expected_classification_hexdump.txt)
	RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

	PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
	PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"
else
	echo -e "${GREEN}Classification works with multi_jpg!${NC}"
fi

##End multi_jpg classification testing
##


##
## lines below here test map with multi_jpg



#creates a hexdump of the generated map file
hexdump -Cv map > actual/multi_jpg/map_hexdump.txt

#compares the difference between the hexdumps and sends them to a diff file
diff actual/multi_jpg/map_hexdump.txt expected/multi_jpg/expected_map_hexdump.txt > actual/multi_jpg/map_hexdump.diff
if [ -s actual/multi_jpg/map_hexdump.diff ]; #if file isn't empty
then
	EXPECTEDSIZE=$(wc -c <"expected/multi_jpg/expected_map_hexdump.txt") #calculate size of the diff file
  DIFFSIZE=$(wc -c <"actual/multi_jpg/map_hexdump.diff")
	echo -e "${RED}Map file is wrong; these are the first few lines of the diff:${NC}"
	head -5 actual/multi_jpg/map_hexdump.diff

	WRONGLINES=$(grep \< -o actual/multi_jpg/map_hexdump.diff | wc -l)
	TOTALLINES=$(wc -l < expected/multi_jpg/expected_map_hexdump.txt)
	RIGHTLINES=`expr $TOTALLINES - $WRONGLINES`

	PERCENT=$(echo $RIGHTLINES / $TOTALLINES \* 100| bc -l)
	PERCENT=$(echo $PERCENT | awk '{printf("%.1f\n",$1)}')  #Rounds up

echo -e "Estimated percent correct is: ${YELLOW}$PERCENT%${NC}"


else
	echo -e "${GREEN}Map works with multi_jpg!${NC}"

fi


# end map multi_jpg testing
#
