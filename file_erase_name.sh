#!/bin/bash
read filename
mysql -u root -proot File<<eof
DELETE FROM A where A.Path="$filename"
eof