#!/bin/sh

totalname=0
cutname=0
filename=0
filetype=0
isfolder=0
isfile=0
# total input 3 arguments from outside: 

# total input 3 arguments: 
# $1: ID
# $2: file number
# $3: file path and name

#####################
#functions define
fgettype()
{
	echo "enter get file type func"
	type=0
	for filename in `ls $1.*`
	do
		if [ $filename = "$1.aria2" ];then
			continue
		fi

		echo "handle file $filename"
		if [ -z "$(exiftool $filename | grep "Error")" ];then
			type=$(exiftool $filename | grep "MIME Type" | cut -d : -f 2 | sed 's/^[ \t]*//g' | cut -d / -f 1)
			filetype=$type
			return 1
		else
			filetype=0
			return 0
		fi
	done
}


####################
# main func
# steps:
# 1: get file name
for totalname in `ls *.aria2`
do
	cutname=$(echo $totalname | cut -d . -f 1)
	if [ -d "$cutname" ];then
		# directly move whole folder
		isfolder=1
	else
		isfile=1
		#filetype=$(fgettype $cutname)
		fgettype $cutname
		if [ -z "$filetype" ];then
			echo "Error: unkonwn file type $filetype"
			return
		else
			echo "$filename type is $filetype"
		fi
	fi

# 2: output file format
#filetype=$(exiftool *.* | grep "MIME Type" | cut -d : -f 2 | sed 's/^[ \t]*//g' | sed 's/$/\n/g')
#echo $filetype
#	for filename in `ls`
#	do
#		if [ -z "$(exiftool $filename | grep "Error")" ];then
#			filetype=$(exiftool $filename | grep "MIME Type" | cut -d : -f 2 | sed 's/^[ \t]*//g')
#               	echo $filename:$filetype
#
#		else	
#			echo Unknown:$filename
#		fi
#	done
# steps:
# 1: get file name


# 2: output file format


# 3: analyzer file format info


# 4: create file folder with format info


# 5: move file to own folder
	if [ $isfile = 1 ];then
		echo "remove $totalname"
		rm $totalname
		echo "move $cutname.* to folder $filetype/"
		mv $cutname.* $filetype/
	fi
done
