# !/bin/bash

# DIR=
SCRIPT=addusers.sh
USERS_FILE="$1"
SERVER="$2"

scp "$SCRIPT" "$SERVER":"$DIR"
scp "$USERS_FILE" "$SERVER":"$DIR"

ssh "$SERVER" bash <<-EOF
	cd ~/"$DIR"
	sudo chmod u+x "$SCRIPT"
	./"$SCRIPT" "$USERS_FILE"
	rm "$SCRIPT" "$USERS_FILE"
EOF

