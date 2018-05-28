#!/bin/bash
#space= df --output=avail -B 1 "$PWD" | tail -n 1
#gives available free space in current directory
total=2500
space=230
size=0
read size
while (($space < $size)) && (($size <= $total))
do
	mysql -u root -proot File<<eof
	rows=SELECT COUNT(*) FROM A;
	$space=$(($space+(Select size from A where A.priority=rows)));
	DELETE FROM A where A.priority=rows;
eof
done