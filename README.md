# Manage SSH Access Tool

A tool for adding SSH access for new users to a set of servers. The tool works by taking in a json file of users with their target usernames and SSH public key strings. A new user is first created on each server using that username and then the SSH public key is added to the `~/.ssh/authorized_keys` file.

---

## Usage

To add new users, simply run the following:
```
./run.sh [users json file]
```

#### Setting up the users json file

A sample users file is illustrated below and included at `sample-users.json` in the repo. The structure is a collection of user objects each containing a respective `username` and `ssh-pubkey` keys & values.
```
{
  "user1": {
    "username": "user1",
    "ssh_pubkey": "ssh-ed25519 key-string-1-here"
  },
  "user2": {
    "username": "user2",
    "ssh_pubkey": "ssh-ed25519 key-string-2-here"
  }
}

```

#### Setting up the SSH config file

This tool works by parsing an ssh config file of a specific format. Firstly, it looks for lines formatted as `Host *<hostname-here>`. It then drops the '`*`' from the hostname and adds the prefix `admin.` to get the ssh path that it will use to try to access the server.

For example, the following entry will result in an ssh lookup of `$ ssh admin.myserver` which would effectively resolve to ` $ ssh ec2-user@192.100.100.1`:
```
# ~/.ssh/config

Host *myserver
  HostName 192.100.100.1

Host admin.*
  User ec2-user
```

*Note: The `admin.` host alias must be present for this script to work as it is a hardcoded parameter within the script.*