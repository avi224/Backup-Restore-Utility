readarray c < conf

ssh_host="indresh@127.0.0.1"
user="indresh"
ssh_user="pramod"
ssh_ip="10.8.20.145"

if [[ $3 == "local" ]]
then

	index=0
	readarray line < $2/backups.log
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done
	
	read -p "Choose backup : " opt

	echo "restoring ${line[$opt]}"

	rsync -avzP --delete $2/${line[$opt]}/ $1/..


elif [[ $3 == "remote" ]]
then

	ssh $ssh_host ' 
	index=0
	readarray line < '"$2/backups.log"'
	while [[ $index -lt ${#line[@]} ]]; do
		echo [$index] ${line[$index]}
		index=$(($index + 1))
	done

	read -p "Choose backup : " opt

	echo "restoring ${line[$opt]}"

	rsync -avzP --delete $2/${line[$opt]}/* -e ssh $ssh_user@$ssh_ip:$1/..
	' 
fi