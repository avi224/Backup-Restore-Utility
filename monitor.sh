readarray c < conf

mode=${c[2]::-1}
src_dir=${c[7]::-1}

inccount=0
update_size=0
backup_limit=${c[6]::-1} #1,073,741,824

./backup.sh full $src_dir  $src_dir.backup $mode

inotifywait -r -m $src_dir -e create -e moved_to -e modify |
    while read path action file; do
    	if [[ $file =~ "swp" ]] 
    	then
    		continue
    	fi
        #echo "The file '$file' appeared in directory '$path' via '$action'"
        FILESIZE=$(stat -c%s "$path$file")
		#echo "Size of $path$file = $FILESIZE bytes."

		update_size=$((update_size + $FILESIZE)) 

		if [[ update_size -gt backup_limit ]]
		then
			./backup.sh inc $src_dir  $src_dir.backup $mode
		fi
    done