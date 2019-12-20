# !/bin/bash

# DIR=
SCRIPT=addusers.sh
USERS_FILE="$1"
SSH_CONFIG_FILE="$2"

adduser () {
	SSH_PATH=$1

	scp "$SCRIPT" "$SSH_PATH":"$DIR"
	scp "$USERS_FILE" "$SSH_PATH":"$DIR"

	ssh "$SSH_PATH" bash <<-EOF
		cd ~/"$DIR"
		sudo chmod u+x "$SCRIPT"
		./"$SCRIPT" "$USERS_FILE"
		rm "$SCRIPT" "$USERS_FILE"
	EOF
}

for ssh_path in $(cat $SSH_CONFIG_FILE | grep '^Host \*\w' | awk '{print $2;}' | cut -c 2-); do
	ssh_user_and_path='admin.'$ssh_path
    echo "Accessing $ssh_user_and_path" && echo "---"
	adduser $ssh_user_and_path
	echo && echo "===================================" && echo
done
