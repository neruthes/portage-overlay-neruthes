# 2022-12-07T00-56-37Z
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
EGIT_COMMIT=a469e6768df4d5d2cb340749fa58e4721a7dee96

DESCRIPTION="An Amazon S3 compatible object storage server"
HOMEPAGE="https://github.com/minio/minio"
SRC_URI="https://github.com/minio/minio/archive/refs/tags/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~amd64-linux"

RESTRICT="test"

DEPEND="
	acct-user/minio
	acct-group/minio
"

S="${WORKDIR}/${PN}-RELEASE.${MY_PV}"

src_prepare() {
	default

	sed -i \
		-e "s/time.Now().UTC().Format(time.RFC3339)/\"${MY_PV}\"/" \
		-e "s/-s //" \
		-e "/time/d" \
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/" \
		buildscripts/gen-ldflags.go || die
}

src_compile() {
	MINIO_RELEASE="${MY_PV}"
	go run buildscripts/gen-ldflags.go || die
	go build \
		--ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
}

src_install() {
	dobin minio

	insinto /etc/default
	doins "${FILESDIR}"/minio.default

	dodoc -r README.md CONTRIBUTING.md docs

	systemd_dounit "${FILESDIR}"/minio.service
	newinitd "${FILESDIR}"/minio.initd minio

	keepdir /var/{lib,log}/minio
	fowners minio:minio /var/{lib,log}/minio
}
