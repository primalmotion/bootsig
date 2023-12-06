PREFIX ?= /usr/local

install:
	install -d -m 755 "$(PREFIX)/var/lib/bootsig"
	install -D -m 755 bootsig-init "$(PREFIX)/usr/bin/bootsig-init"
	install -D -m 755 bootsig-sign "$(PREFIX)/usr/bin/bootsig-sign"
	install -D -m 755 bootsig-verify "$(PREFIX)/usr/bin/bootsig-verify"
	install -D -m 755 bootsig-check "$(PREFIX)/usr/bin/bootsig-check"
	install -D -m 644 bootsig-config "$(PREFIX)/etc/bootsig/config"
	install -D -m 644 bootsig-functions "$(PREFIX)/usr/lib/bootsig/functions"
	chmod 755 "$(PREFIX)/usr/lib/bootsig"

install-systemd:
	install -D -m 644 bootsig.service "$(PREFIX)/usr/lib/systemd/system/bootsig.service"
	install -D -m 644 bootsig.timer "$(PREFIX)/usr/lib/systemd/system/bootsig.timer"

install-pacman-hook:
	install -D -m 644 99-bootsig.hook "$(PREFIX)/etc/pacman.d/hooks/99-bootsig.hook"

uninstall:
	rm -rf "$(PREFIX)/usr/bin/bootsig-init"
	rm -rf "$(PREFIX)/usr/bin/bootsig-sign"
	rm -rf "$(PREFIX)/usr/bin/bootsig-verify"
	rm -rf "$(PREFIX)/usr/bin/bootsig-check"
	rm -rf "$(PREFIX)/var/lib/bootsig"
	rm -rf "$(PREFIX)/usr/lib/bootsig"
	rm -rf "$(PREFIX)/etc/bootsig"
	rm -rf "$(PREFIX)/usr/lib/systemd/system/bootsig.service"
	rm -rf "$(PREFIX)/usr/lib/systemd/system/bootsig.timer"
	rm -rf "$(PREFIX)/etc/pacman.d/hooks/99-bootsig.hook"
	rm -rf "$(PREFIX)/boot/boot.sum"
	rm -rf "$(PREFIX)/boot/boot.count"
