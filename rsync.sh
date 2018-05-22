d=$(date)
d=${d// /.}
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