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
	ssh $3 ' 
	index=0
	readarray line < '"$1/backups.log"'
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done'
fi