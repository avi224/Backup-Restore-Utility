readarray c < conf

ssh_host=${c[0]}

ssh-keygen -t rsa

echo "Enter path of key"
read path

ssh-copy-id -i $path $ssh_host