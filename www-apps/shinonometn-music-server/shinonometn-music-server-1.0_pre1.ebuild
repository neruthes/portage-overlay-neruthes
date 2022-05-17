# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp

DESCRIPTION="Music streaming server"
HOMEPAGE="https://github.com/ShinonomeTN/music-server"
SRC_URI="https://github.com/ShinonomeTN/music-server/archive/refs/tags/${PV/_pre1/-SNAPSHOT}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
REQUIRED_USE=""

DEPEND=""
RDEPEND="
	virtual/jre
"

S=${WORKDIR}/${PN}

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	# webapp_src_preinst
	HTDIR="${D}/var/www/shinonometn-music-server"
	CONFDIR="${HTDIR}/conf"
	dodir "${CONFDIR}"

	insinto "${HTDIR}"
	doins -r .
	dodir "${HTDIR}"/data

	webapp_serverowned -R "${HTDIR}"/apps
	webapp_serverowned -R "${HTDIR}"/data
	webapp_serverowned -R "${HTDIR}"/config

	webapp_src_install
}
