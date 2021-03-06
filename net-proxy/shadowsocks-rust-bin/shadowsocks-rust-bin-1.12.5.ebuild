# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MULTILIB_COMPAT=( abi_mips_n32 )

inherit systemd

DESCRIPTION="A Rust port of shadowsocks"
HOMEPAGE="https://github.com/shadowsocks/shadowsocks-rust"

SRC_URI="
	amd64?	( https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${PV}/shadowsocks-v${PV}.x86_64-unknown-linux-gnu.tar.xz )
	arm?	( https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${PV}/shadowsocks-v${PV}.arm-unknown-linux-gnueabi.tar.xz )
	arm64?	( https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${PV}/shadowsocks-v${PV}.aarch64-unknown-linux-gnu.tar.xz )
	mips?	( https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${PV}/shadowsocks-v${PV}.mipsel-unknown-linux-musl.tar.xz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~mips"	#mips not tested
RESRICT="mirror"
IUSE="big-endian"
REQUIRED_USE="mips? ( !big-endian )"
S="${WORKDIR}"

QA_PREBUILT="
	usr/bin/sslocal-rust
	usr/bin/ssmanager-rust
	usr/bin/ssserver-rust
	usr/bin/ssurl-rust
"

src_install() {
	newbin "${S}/sslocal" sslocal-rust
	newbin "${S}/ssmanager" ssmanager-rust
	newbin "${S}/ssserver" ssserver-rust
	newbin "${S}/ssurl" ssurl-rust

	systemd_newunit "${FILESDIR}/shadowsocks-rust_at.service" shadowsocks-rust@.service
	systemd_newunit "${FILESDIR}/shadowsocks-rust-server_at.service" shadowsocks-rust-server@.service

	keepdir /etc/shadowsocks
}
