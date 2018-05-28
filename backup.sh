d=$(date)
d=${d// /.}

readarray c < conf

ssh_user=${c[0]::-1}
ssh_ip=${c[1]::-1}


if [[ $4 == "local" ]]
then 
	
	mkdir -p $3

	if [ -f "$3/backups.log" ]
	then
		prevdate=$(tail -n 1 $3/backups.log)
	else
		echo "creating log file..."
		touch $3/backups.log 
	fi
	
	if [[ $1 == 'inc' ]]
	then

		if [[ $prevdate == "" ]]
		then
			echo "Error: No previous full backup exists"
			exit 1
		fi

		tar -xzvf $3/$prevdate.tar.gz --directory=$3
		mv $3/$prevdate $3/$d
	fi

	rsync -avzP --delete $2 $3/$d

	tar -czvf $3/$d.tar.gz --directory=$3 $d

	rm -rf $3/$d

	echo $d $3 >> backups.log  
	echo $d >> $3/backups.log

elif [[ $4 == "remote" ]]
then
	ssh $ssh_user@$ssh_ip 'mkdir -p '"$3"'
	
	if  [ -f '"$3/backups.log"' ]
	then
		prevdate=$(tail -n 1 '"$3/backups.log"' )
	else
		touch '"$3/backups.log"' 
		echo "creating log file..."
	fi
	
	if [[ '"$1"' == "inc" ]]
	then
		if [[ $prevdate == "" ]]
		then
			echo "Error: No previous full backup exists"
			exit 1 
		fi
		tar -xzvf '"$3"'/$prevdate.tar.gz --directory='"$3"'
		mv '"$3"'/$prevdate '"$3/$d"'
	fi
	'

	rsync -avzP --delete $2 -e ssh $ssh_user@$ssh_ip:$3/$d

	ssh $ssh_user@$ssh_ip 'tar -czvf '"$3/$d"'.tar.gz --directory='"$3 $d"'

	rm -rf '"$3/$d"'
  
	echo '"${d} >> ${3}/backups.log"

	echo $d $3 >> backups.log
fi