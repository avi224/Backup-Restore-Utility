update_size=0
backup_limit=1,073,741,824
inotifywait -r -m /home/indresh/ML -e create -e moved_to -e modify |
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
			echo "Backup"
		fi
    done