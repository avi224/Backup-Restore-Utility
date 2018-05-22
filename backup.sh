d=$(date)
d=${d// /.}

readarray c < conf

ssh_host=${c[0]}

if [[ $4 == "local" ]]
then 

	prevdate=$( tail -n 1 $3/backups.log )

	if [[ $1 == 'inc' ]]
	then
		cp -r $3/$prevdate $3/tmp
		mv $3/$prevdate $3/$d
		mv $3/tmp $3/$prevdate
	fi

	rsync -avzP --delete $2 $3/$d

	echo $d $3 >> backups.log  
	echo $d >> $3/backups.log

elif [[ $4 == "remote" ]]
then
	if ssh $ssh_host [ -f "$3/backups.log" ]
	then
		prevdate=$( ssh $ssh_user@$ssh_ip "tail -n 1 $3/backups.log" )
	else
		ssh $ssh_host touch $3/backups.log 
		echo "creating log file..."
	fi
	
	if [[ $1 == 'inc' ]]
	then
		ssh $ssh_host "cp -r $3/$prevdate $3/tmp"
		ssh $ssh_host "mv $3/$prevdate $3/$d"
		ssh $ssh_host "mv $3/tmp $3/$prevdate"
	fi

	rsync -avzP --delete $2 -e ssh $ssh_host:$3/$d

	echo $d $3 >> backups.log  
	ssh $ssh_host "echo ${d} >> ${3}/backups.log"
fi