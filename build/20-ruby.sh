#!/bin/bash
##20-ruby.sh: Builds Ruby GEMs
##@copyright GPL-2.0+
abtryexe ruby gem || ((!ABSTRICT)) || ablibret

build_ruby_build(){
	GEMDIR="$(ruby -e'puts Gem.default_dir')"
	abinfo "Building and installing Ruby (Gem) package ..."
	gem install --ignore-dependencies --no-user-install \
		-i "$PKGDIR/$GEMDIR" -n "$PKGDIR/usr/bin" "$PKGNAME-$PKGVER.gem"
	abinfo 'Removing Gem cache from $PKGDIR ...'
	rm -v "$PKGDIR/$GEMDIR/cache/"*
}

build_ruby_probe(){ false; }

ABBUILDS+=' ruby'
