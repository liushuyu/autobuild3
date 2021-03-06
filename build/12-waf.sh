#!/bin/bash
##12-waf.sh: Builds WAF stuff
##@copyright GPL-2.0+
abtryexe python2 || ablibret

build_waf_probe(){
	[ -f waf ]
}

build_waf_build(){
	local _ret
	BUILD_START
	abinfo "Running Waf script(s) ..."
	python2 waf configure ${WAF_DEF} ${WAF_AFTER} || _ret="${PIPESTATUS[0]}"
	BUILD_READY
	abinfo "Building binaries ..."
	python2 waf build ${ABMK} ${MAKE_AFTER} ${MAKEFLAGS} || _ret="${PIPESTATUS[0]}"
	BUILD_FINAL
	abinfo "Installing binaries ..."
	python2 waf install --destdir=${PKGDIR} || _ret="${PIPESTATUS[0]}"
	return $_ret
}
ABBUILDS+=' waf'
