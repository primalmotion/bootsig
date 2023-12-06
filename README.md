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

- creates a new gpg keyring /usr/lib/bootsig/bootsig-keyring
- imports the key given as arguments into that keyring
- run `gpg --card-status` to create the stubs (if you use a smartcard)

### Signature

- count the files (beside `boot.sum` and `boot.count`) and write the number in
  `/boot/boot.count`
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

## Usage

First export one of your keys

    gpg --export-secret-keys 387CC53BDF8C1142FC66832778B51E298FC66E62 > /tmp/secret.key

Then initialize bootsig:

    sudo bootsig-init /tmp/secret.key

Then sign your boot partition:

    sudo bootsig-sign

You will be prompted for your passphrase (or your pin if you use smartcard) to
sign `/boot/boot.sum` and `/boot/boot.count`

## Systemd integration

You can start a timer that will verify regularly the signature:

    systemd enable --now bootsig.timer

## Pacman integration

On Arch, you can make pacman run the verification after updating several key
packages.

    sudo mkdir -p /etc/pacman.d/hooks/
    sudo cp 99-bootsig.hook /etc/pacman.d/hooks

## Post script

You probably want to know if the boot integrity is not cheking up, like showing
a notification, or updating your bar or anything

It is important for security reason that this script is owned and only writable
by root:

    sudo chown root:root /usr/lib/bootsig/post-verify
    sudo chmod 755 /usr/lib/bootsig/post-verify

### Notify-send example

Write a script in `/usr/lib/bootsig/post-verify`:

    if [[ "$1" != "0" ]]; then
	sudo -u antoine \
		DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
		notify-send -w --urgency critical bootsig '/boot integrity check failed'
    fi


### Waybar example

Add the following custom item in your waybar config

    ...
    "custom/sigmismatch": {
		"interval": "once",
		"signal": 8,
		"exec-if" : "! bootsig-check",
		"format": "Boot Signature Mismatch",
		"exec": "echo -n",
	},
    ...

Then write a script in `/usr/lib/bootsig/post-verify`:

    #!/bin/bash
    pkill -RTMIN+8 waybar
