readarray c < conf

mode=${conf[1]}
user=${conf[2]}

update_size=0
backup_limit=200 #1,073,741,824
src_dir=/home/indresh/makfile
inotifywait -r -m $src_dir -e create -e moved_to -e modify |
    while read path action file; do
    	if [[ $file =~ "swp" ]] 
    	then
    		continue
    	fi
        echo "The file '$file' appeared in directory '$path' via '$action'"
        FILESIZE=$(stat -c%s "$path$file")
		echo "Size of $path$file = $FILESIZE bytes."

		update_size=$((update_size + $FILESIZE)) 

		if [[ update_size -gt backup_limit ]]
		then
			./backup.sh inc $src_dir $user $mode
		fi
    done