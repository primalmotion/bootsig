# Maintainer: Primalmotion <primalmotion at pm dot me>

pkgname=bootsig
pkgdesc="A poor man's /boot signature validator"
url="https://github.com/primalmotion/bootsig"
pkgver=1.0.0
pkgrel=1
license=(GPL3)
arch=(x86_64 arm64)
depends=(gnupg)
source=("bootsig-functions"
		"bootsig-config"
		"bootsig-init"
		"bootsig-sign"
		"bootsig-verify"
		"bootsig-check"
		"bootsig.service"
		"bootsig.timer"
		"Makefile"
		"99-bootsig.hook")
sha256sums=('3b7aa38ca46787f4c3dcb4b899f96ae4065cc682a7608fe604cc1c591f21d9cb'
            'f09a7e7729885c8c79ca81ac94ff42d634bc4ce47f5e1527ac501db3d60c324f'
            '82910b54a9ca447f563c76dbe228a135f7585e9b529324157f94ac2eeef55ca8'
            'd7655108dc99dbfc19bcdc7063fa3403a7fa4280dbfeeade6339f1feb87edae8'
            '0a4cbe66f9c28d0c2381678f5e29f7698a666681f2cd8730095e0f7a13429c73'
            'e7a1e815bb5ec41c65db7d8ca3b1c111281da87d267d69ef8887eb2c14f3ef2f'
            '238f9b7801d74a18df03956675a773b04237549a6e8012f9b60a6d27ac68d008'
            '82c56268084aca591f421c477b692ebcfb14588adab1902fa96184b39ceac207'
            '6247894e0371e3c0db01261582d46fd957e297f46ff9aa5336bd8ae94c221b87'
            '6e728ffb6eb034fa076c3bd09ea42bcb70cd73a4bed1967f9aeaf74d84019c94')
provides=("bootsig")

package() {
	PREFIX="${pkgdir}" make install
	install -D -m 644 bootsig.service "${pkgdir}/usr/lib/systemd/system/bootsig.service"
	install -D -m 644 bootsig.timer "${pkgdir}/usr/lib/systemd/system/bootsig.timer"
	install -D -m 644 99-bootsig.hook "${pkgdir}/etc/pacman.d/hooks/99-bootsig.hook"
}
