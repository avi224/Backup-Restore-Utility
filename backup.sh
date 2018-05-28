d=$(date)
d=${d// /.}

readarray c < conf

ssh_host=${c[0]}
user="indresh"
ssh_user="pramod"
ssh_ip="10.8.20.145"

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

		tar -xzvf $3/prevdate.tar.gz
		cp -r $3/$prevdate $3/tmp
		mv $3/$prevdate $3/$d
		mv $3/tmp $3/$prevdate
	fi

	rsync -avzP --delete $2 $3/$d

	tar -czvf $3/$d.tar.gz $3/$d

	rm -rf $3/$d

	echo $d $3 >> backups.log  
	echo $d >> $3/backups.log

elif [[ $4 == "remote" ]]
then
	ssh $ssh_host "mkdir -p $3"
	
	if ssh $ssh_host [ -f "$3/backups.log" ]
	then
		prevdate=$( ssh $ssh_user@$ssh_ip "tail -n 1 $3/backups.log" )
	else
		ssh $ssh_user@$ssh_ip touch $3/backups.log 
		echo "creating log file..."
	fi
	
	if [[ $1 == 'inc' ]]
	then
		if [[ $prevdate == "" ]]
		then
			echo "Error: No previous full backup exists"
			exit 1 
		fi

		ssh $ssh_user@$ssh_ip "cp -r $3/$prevdate $3/tmp"
		ssh $ssh_user@$ssh_ip "mv $3/$prevdate $3/$d"
		ssh $ssh_user@$ssh_ip "mv $3/tmp $3/$prevdate"
	fi

	rsync -avzP --delete $2 -e ssh $ssh_user@$ssh_ip:$3/$d

	echo $d $3 >> backups.log  
	ssh $ssh_user@$ssh_ip "echo ${d} >> ${3}/backups.log"
fi