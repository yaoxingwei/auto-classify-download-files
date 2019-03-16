#!/bin/sh

btname=0
output_file=0
bt_folder=/home/yxw/share/github/torsniff/torrents

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
            echo $dir_or_file >> test.log
            aria2c -S $dir_or_file | grep -E "Name:|Total Length:" >> test.log
            echo "\n" >> test.log
        fi  
    done
}


### main ###
getdir $bt_folder

#aria2c -S torrents/01/55/*.torrent | grep -E "Name:|Total Length:"
