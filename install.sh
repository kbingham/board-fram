#!/bin/sh

# -g fram - Common group for all fram users
# -d <dir> - Target $HOME for the new board user
# -r
# -s <shell> - Specify shell.

BOARD_USER=$1
TARGET=/home/fram/targets/$BOARD_USER

useradd -r -s /bin/sh -g fram -m $BOARD_USER -d $TARGET

# Only needed if the target is using a local serial console
usermod -a -G dialout $BOARD_USER


install -m 744 -g fram -o $BOARD_USER -d $TARGET/authorized_keys.d
install -m 644 -g fram -o $BOARD_USER \
	./authorized_keys.d/* \
	$TARGET/authorized_keys.d

# Prepare a board specific key
su $BOARD_USER -c /usr/bin/ssh-keygen

# And configure users to access through fram
su $BOARD_USER -c ./update-ssh-keys
