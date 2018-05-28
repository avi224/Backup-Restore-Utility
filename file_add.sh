#!/bin/bash
priority=0
size=0
read filename
read timestamp
read priority
read size
mysql -u root -proot File<<eof
UPDATE A SET A.priority=A.priority+1 where A.priority>=$priority;
INSERT INTO A(Path,timestamp,priority,size) values("$filename","$timestamp",$priority,$size);
eof