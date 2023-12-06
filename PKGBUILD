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
            'c0ac87e1e837296a72b171676c59484f4bf34baf875e79ac5d2274212c8a1319'
            'd7655108dc99dbfc19bcdc7063fa3403a7fa4280dbfeeade6339f1feb87edae8'
            '0a4cbe66f9c28d0c2381678f5e29f7698a666681f2cd8730095e0f7a13429c73'
            'e7a1e815bb5ec41c65db7d8ca3b1c111281da87d267d69ef8887eb2c14f3ef2f'
            '238f9b7801d74a18df03956675a773b04237549a6e8012f9b60a6d27ac68d008'
            '82c56268084aca591f421c477b692ebcfb14588adab1902fa96184b39ceac207'
            '857dd503acfe2ef286ebaf6be1959da2d2bd894425c84d3d71eaa01df057b2a0'
            '6e728ffb6eb034fa076c3bd09ea42bcb70cd73a4bed1967f9aeaf74d84019c94')
provides=("bootsig")

package() {
	PREFIX="${pkgdir}" make install install-systemd install-pacman-hook
}
