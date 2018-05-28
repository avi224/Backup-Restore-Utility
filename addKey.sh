readarray c < conf

ssh_user=${c[0]::-1}
ssh_ip=${c[1]::-1}

ssh-keygen -t rsa

echo "Enter path of key"
read path

ssh-copy-id -i $path $ssh_user@$ssh_ip