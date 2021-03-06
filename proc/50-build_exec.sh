#!/bin/bash
##proc/build_do: So we build it now
##@copyright GPL-2.0+
arch_loadfile_strict prepare

for build_func in build_{start,ready,final}; do
	abcmdstub "$build_func"
	alias "${build_func^^}=_ret=\$PIPESTATUS
	if ((_ret)); then
		bool \$ABSHADOW && cd ..
		return \$_ret
	fi
	echo $build_func | ablog
	$build_func || abwarn '$build_func: \$?'
	for _quirk in \$PKGQUIRKS; do
		if [[ \$_quirk == */* ]]; then
			[[ \$_quirk == ${build_func/#build_}/* ]] || continue
		else
			_quirk=${build_func/#build_}/\$_quirk
		fi
		if [ -e \"\$AB/quirks/\$_quirk\" ]; then
			. \"\$AB/quirks/\$_quirk\"
		fi
	done"
done

build_${ABTYPE}_build || abdie "Build failed: $?."

cd "$SRCDIR" || abdie "Unable to cd $SRCDIR: $?."

[ -d "$PKGDIR" ] || abdie "50-build: Suspecting build failure due to missing PKGDIR."

if [ -d "$(arch_findfile overrides)" ] ; then
	cp -ra "$(arch_findfile overrides)"/* "$PKGDIR/"
fi

arch_loadfile_strict beyond

unalias BUILD_{START,READY,FINAL}

# Inline: QA Dir
if bool "$ABQA"; then
	[ -e "$PKGDIR/usr/local" ] && abicu "QA: found \$PKGDIR/usr/local." || true
fi
