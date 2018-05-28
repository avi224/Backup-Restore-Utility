readarray c < conf

user=${c[3]::-1}
ssh_user=${c[0]::-1}
ssh_ip=${c[1]::-1}
ip=${c[4]::-1}

if [[ $3 == "local" ]]
then

	index=0
	readarray line < $2/backups.log
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done
	
	read -p "Choose backup : " opt

	echo "restoring ${line[$opt]::-1}"

	tar -xzvf $2/${line[$opt]::-1}.tar.gz --directory=$2

	rsync -avzP --delete $2/${line[$opt]::-1}/* $1/..

	rm -rf $2/${line[$opt]::-1}

elif [[ $3 == "remote" ]]
then

	ssh $ssh_user@$ssh_ip ' 
	index=0
	readarray line < '"$2/backups.log"'
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done

	read -p "Choose backup : " opt

	echo "restoring ${line[$opt]::-1}"

	echo rsync -avzP --delete '"$2"'/${line[$opt]::-1}/* -e ssh '"$user@$ip:$1/.."'
	' 
fi