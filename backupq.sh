if [[ $1 == "local" ]]
then
	rsync -avz --delete $2 $3