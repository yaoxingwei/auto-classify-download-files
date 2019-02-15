#!/bin/sh

totalname=0
cutname=0
filename=0
filetype=0
isfolder=0
isfile=0
foldertype=0
# total input 3 arguments from outside: 

# total input 3 arguments: 
# $1: ID
# $2: file number
# $3: file path and name

#####################
#functions define
####################
# get file size
fgetsize()
{
	stat -c %s $1 | tr -d '\n'
}

# use to get file $1.* type, except $1.aria2
fgettype()
{
	echo "enter get $1 file type func"
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

# use to check folder file, and get the largest file type to the need type
fgetfoldertype()
{
	maxfilesize=0
	maxfilename=0
	tempsize=0
	tempfile=0

	echo "enter get $1 folder type func"
	cd $1
	for tempfile in `ls *.*`
	do
		tempsize=$(fgetsize $tempfile)
		echo "$tempfile:$tempsize"
		if [ $tempsize = 0 ];then
			rm $tempfile
		fi

		if [ $tempsize -gt $maxfilesize ];then
			maxfilesize=$tempsize
			maxfilename=$tempfile
		fi
	done
	foldertype=$(exiftool $maxfilename | grep "MIME Type" | cut -d : -f 2 | sed 's/^[ \t]*//g' | cut -d / -f 1)
	echo "max file $maxfilename size:$maxfilesize type:$foldertype"
	cd ..
}

####################
# main func
# steps:
# 1: get file name
#for totalname in `ls *.aria2`
for totalname in $3.aria2
do
	cutname=$(echo $totalname | cut -d . -f 1)
	if [ -d "$cutname" ];then
		# directly move whole folder
		isfolder=1
		isfile=0
		fgetfoldertype $cutname
	else
		isfile=1
		isfolder=0
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
		mkdir $cutname
		mv $cutname.* $cutname
		mv $cutname $filetype/
	fi

	if [ $isfolder = 1 ];then
		echo "remove $totalname and move folder"
		rm $totalname
		mv $cutname $foldertype/
	fi

	echo "========================="
done
