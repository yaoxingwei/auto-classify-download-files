#!/bin/sh

btname=0
output_file=bt_info.log
bt_folder=/home/yxw/share/github/torsniff/torrents
old_name=0
trans_name=0

### func ###
getdir()
{
    for element in `ls $1`
    do
        #echo $element
        dir_or_file=$1/$element
        #echo $dir_or_file
        if [ -d $dir_or_file ]
        then
            #echo "if folder" 
            getdir $dir_or_file
        elif [ -f $dir_or_file ]
        then
            #echo "is file!!"
            #echo $(pwd)
            #echo $dir_or_file
            echo $dir_or_file >> $output_file
            aria2c -S $dir_or_file | grep -E "Name:|Total Length:" >> $output_file
	    old_name=$(aria2c -S $dir_or_file | grep -E "Name:")
	    trans_name=$(./trans :zh -b -e google -no-autocorrect "$temp_name")
	    echo $trans_name >> $output_file
	    echo "\n" >> $output_file
        fi  
    done
}


### main ###
getdir $bt_folder
