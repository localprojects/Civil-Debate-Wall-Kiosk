#!/bin/bash

# findOrphans
# designed by Tom Schober
# http://tomschober.com

# Copyright (C) 2011 by Tom Schober
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

usage()
{
cat << EOF
usage: $0 options

Script to find unused class names in a Flex Project

OPTIONS:
   -h      Show this message
   -f      Flex Home.  Must be Flex 4.1 or higher due to need for swfdump (required)
   -p      Project Root Folder (required)
   -l      List of source folders relative to project root (comma delimited: "/firstSource,/secondSource") (required)
   -s      Path to the SWF (before OR after build) (required)
   -o      Output Directory Root (required)

EOF
}

FLEXHOME=/Applications/Adobe\ Flash\ Builder\ 4.5/sdks/4.5.1
PROJECTROOT=~/Code/CivilDebateWall/lp-cdw/air_projects/cdw_kiosk
SOURCEFOLDERS=src
SWFPATH=~/Code/CivilDebateWall/lp-cdw/air_projects/cdw_kiosk/bin-debug/Main.swf
OUTPUTROOT=~/Code/CivilDebateWall/lp-cdw/air_projects/cdw_kiosk/orphan-report

while getopts â€œhf:p:l:s:o:â€ OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         f)
             FLEXHOME=$OPTARG
             ;;
         p)
             PROJECTROOT=$OPTARG
             ;;
         l)
             SOURCEFOLDERS=$OPTARG
             ;;
         s)
             SWFPATH=$OPTARG
             ;;
         o)
             OUTPUTROOT=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $FLEXHOME ]] || [[ -z $PROJECTROOT ]] || [[ -z $OUTPUTROOT ]] || [[ -z $SWFPATH ]] || [[ -z $SOURCEFOLDERS ]]
then
     usage
     exit 1
fi

if [ ! -d "$FLEXHOME" ]; then
	echo "Directory ($FLEXHOME) does not exist"
	exit
fi

if [ ! -d "$PROJECTROOT" ]; then
	echo "Directory ($PROJECTROOT) does not exist"
	exit
fi

if [ ! -d "$OUTPUTROOT" ]; then
	mkdir $OUTPUTROOT
fi

if [[ ! -z "$SWFPATH" ]] && [[ ! -e "$SWFPATH" ]]; then
	echo "Specified SWF PATH (-s) $SWFPATH does not exist"
	exit 1
fi

rm -f asFilePaths
rm -f mxmlFilePaths
rm -f validFiles
rm -f unusedNames
rm -f unusedValidFiles
rm -f possibleCodeBehind

echo "Disassembling SWF..."
swfdumpPath=$FLEXHOME"/lib/swfdump.jar"
java -ea -Dapplication.home="$FLEXHOME" -Xms32m -Xmx384m -jar "$swfdumpPath" -abc "$SWFPATH" > projectSwfDump

echo "Searching for files in source directories..."
declare -a sourceDirectoryArray
sourceDirectoryArray=(`echo ${SOURCEFOLDERS//,/ }`)

for sourceDirectory in "${sourceDirectoryArray[@]}"
do
	if [ -d "$PROJECTROOT/$sourceDirectory" ]; then
		find "$PROJECTROOT/$sourceDirectory" -type f -name "*.as" > asFilePaths
		find "$PROJECTROOT/$sourceDirectory" -type f -name "*.mxml" >> mxmlFilePaths
	else
		echo "Source directory does not exist: $PROJECTROOT/$sourceDirectory"
		exit 1
	fi
done

echo "Searching for code-behind and listing Actionscript classes..."
for filePath in $(<asFilePaths) ;
do
	packageString=$(grep "package[[:space:]]\{0,1\}\(.\{1,\}\(\..\{1,\}\).\{1,\}\)\{0,1\}" $filePath)
	
	if [[ -z $packageString ]]; then
		# There is no package definition so this is not a class.  Must be code-behind!
		echo $filePath >> possibleCodeBehind
		echo "[CODE-BEHIND] $filePath"
	else
		echo $filePath >> validFiles
	fi
done

echo "Listing MXML classes..."
for filePath in $(<mxmlFilePaths) ;
do
	echo $filePath >> validFiles
done

echo "Searching for orphaned classes..."
tput sc
echo -n ""

for validFile in $(<validFiles) ;
do
	pathSegment=$(expr "$validFile" : ".*$SOURCEFOLDERS\(.*\)\..*")
	fullyQualifiedClassName=${pathSegment//\//.}

	tput rc
	tput el
	tput sc
  	echo -n " ORPHAN TEST    : $fullyQualifiedClassName"
	
	dumpSearchResult=( $(grep $fullyQualifiedClassName projectSwfDump) )
	
	if [ ${#dumpSearchResult[@]} == 0 ]; then
		echo $fullyQualifiedClassName >> unusedNames
		echo $validFile >> unusedValidFiles
		
		tput rc
		tput el
		echo "[ORPHANED CLASS] $fullyQualifiedClassName"
		tput sc
	fi
done

tput rc
tput el
echo "Orphan Search Complete"

echo ""

echo "Creating output directory..."
outputDirectory="$OUTPUTROOT/$(date +%Y%m%d-%H%M%S)"
mkdir $outputDirectory

echo "Formatting output..."
sort unusedNames > $outputDirectory/UnusedClasses
sort unusedValidFiles > $outputDirectory/UnusedClassFiles
sort possibleCodeBehind > $outputDirectory/PossibleCodeBehind


echo "Results:"
if [ -e "$outputDirectory/UnusedClasses" ]; then
	echo $(cat $outputDirectory/UnusedClasses | wc -l)" Unused Classes"
else
	echo "No Unused Classes Detected!"
fi

if [ -e "$outputDirectory/PossibleCodeBehind" ]; then
	echo $(cat $outputDirectory/PossibleCodeBehind | wc -l)" Possible Code-Behind Instances"
else
	echo "No Possible Code-Behind Instances Detected!"
fi

# Cleanup
rm -f projectSwfDump
rm -f asFilePaths
rm -f mxmlFilePaths
rm -f validFiles
rm -f unusedNames
rm -f unusedValidFiles
rm -f possibleCodeBehind