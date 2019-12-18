# !/bin/bash

USERS_FILE="$1"

add_user () {
	if [ -n "$1" ]; then
		NEW_USER="$1"
	fi

	if [ -n "$2" ]; then
		PUBLIC_KEY="$2"
	fi

	sudo adduser $NEW_USER
	sudo -i -u $NEW_USER bash <<- EOF
		cd
		mkdir -p .ssh
		chmod 700 .ssh
		touch .ssh/authorized_keys
		chmod 600 .ssh/authorized_keys
		echo $PUBLIC_KEY >> .ssh/authorized_keys
	EOF
}

for user in $(jq keys[] $USERS_FILE); do
        NEW_USER=$(jq .$user.username $USERS_FILE | sed 's/"//g')
        PUBLIC_KEY=$(jq .$user.ssh_pubkey $USERS_FILE)

	if id -u $NEW_USER >/dev/null 2>&1; then
		echo && echo "Skipping $NEW_USER, user already exists"
	else
		echo && echo "Creating user \"$NEW_USER\" and adding the following public ssh key:"
		echo $PUBLIC_KEY
		add_user "$NEW_USER" "$PUBLIC_KEY"
	fi
done

