readarray c < conf

ssh_user=${c[0]::-1}
ssh_ip=${c[1]::-1}

if [[ $2 == "local" ]]
then
	index=0
	readarray line < $1/backups.log
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done
elif [[ $2 == "remote" ]]
then
	ssh $ssh_user@$ssh_ip ' 
	index=0
	readarray line < '"$1/backups.log"'
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done'
fi