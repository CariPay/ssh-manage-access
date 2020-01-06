# !/bin/bash

# DIR=
SCRIPT=addusers.sh
SSH_DIR=$HOME/.ssh
SSH_CONFIG_FILE=$SSH_DIR/config
USERS_FILE="$1"

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

run_add () {
	for ssh_path in $(cat $SSH_CONFIG_FILE | grep '^Host \*\w' | awk '{print $2;}' | cut -c 2-); do
		ssh_user_and_path='admin.'$ssh_path
	    echo "Accessing $ssh_user_and_path" && echo "---"
		adduser $ssh_user_and_path
		echo && echo "===================================" && echo
	done
}

if [ -f $SSH_CONFIG_FILE ]; then
	run_add
else
	echo "Please generate an ssh config file in the expected format at '~/.ssh/config' and then rerun script"
fi
