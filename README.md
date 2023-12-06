# bootsig

Bootsig is the poor man's pureboot /boot integrity checks.

It is made of the following components

- `bootsig-init`: initialize gpg keychain with one key to sign /boot
- `bootsig-sign`: signs the /boot folder
- `bootsig-verify`: verifies the signatures of /boot files
- `bootsig-check`: userland quick check

## Concepts

The integrity is checked using the following process

### Initialization

- creates a new gpg keyring `/usr/lib/bootsig/bootsig-keyring`
- imports the key given as arguments into that keyring
- run `gpg --card-status` to create the stubs (if you use a smartcard)

### Signature

- generate the `sha256sum` for data in `/boot` and store it in `/boot/boot.sum`
- count the files and write the number in `/boot/boot.count`
- signs `boot.sum` and `boot.count`
- stores the signatures in `/var/lib/bootsig`

### Verification

- check the signature of `boot.sum` and `boot.count`
- verify the `sha256sum` of all files in `/boot`
- verify the number of files is still equal to what is stored in `boot.count`
- write a status file in `/usr/lib/bootsig/bootsig-status`
- eventually runs a post script from `/usr/lib/bootsig/post-verify`

### User check

- exit 0 or 1 based on the content of `/usr/lib/bootsig/bootsig-status`

## Installation

You can use the PKGBUILD if you are on arch, or run the `install` target from
the provided `Makefile`

    PREFIX= make install

If you want to install the systemd files:

    PREFIX= make install-systemd
    systemctl enable --now bootsig.timer

If you want to install the pacman hook (Arch and derivatives):

    PREFIX= make install-pacman-hook

## Usage

First export one of your keys

    gpg --export-secret-keys [KEY-ID] > /tmp/secret.key

Then initialize bootsig:

    sudo bootsig-init /tmp/secret.key

Then sign your boot partition:

    sudo bootsig-sign

You will be prompted for your passphrase (or your pin if you use a smartcard) to
sign `/boot/boot.sum` and `/boot/boot.count`

## Post script

You probably want to know if the boot partition has been tampered with, like
showing a notification, or updating your bar or something else. `bootsig-verify`
will check the presence of `/usr/lib/bootsig/post-verify` and will execute it if
present. The first argument will be `0` if the signatures check, `1` otherwise.

It is important for security reason that this script is owned and only writable
by root:

    sudo chown root:root /usr/lib/bootsig/post-verify
    sudo chmod 755 /usr/lib/bootsig/post-verify

> NOTE: the script will not be executed if not owned by root and perms are not
> set to 755

### Notify-send example

Write a script in `/usr/lib/bootsig/post-verify`:

    #!/bin/bash
    if [[ "$1" != "0" ]]; then
	  sudo -u YOURUSERNAME \
	    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
		notify-send --urgency critical bootsig '/boot integrity check failed'
    fi

### Waybar example

Add the following custom item in your waybar config

    "custom/sigmismatch": {
		"interval": "once",
		"signal": 8,
		"exec-if" : "! bootsig-check",
		"format": "Boot Signature Mismatch",
		"exec": "echo -n",
	},

Then write a script in `/usr/lib/bootsig/post-verify`:

    #!/bin/bash
    pkill -RTMIN+8 waybar
