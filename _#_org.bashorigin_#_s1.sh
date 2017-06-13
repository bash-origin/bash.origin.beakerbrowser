#!/usr/bin/env bash.origin.script

local rtBasePath="$__RT_DIRNAME__"
local dmgPath="${rtBasePath}/browser.dmg"
local cdrPath="${rtBasePath}/browser.dmg~.cdr"
local mountPath="${rtBasePath}/browser.dmg~.mount"
local appPath="${rtBasePath}/Browser.app"
local binPath="${appPath}/Contents/MacOS/Beaker Browser"


function PRIVATE_ensure_browser {

	# @see https://github.com/sourcemint/sm-plugin-dmg/blob/master/plugin.js

	if [ ! -e "$appPath" ]; then

		if [ ! -e "$mountPath" ]; then

			if [ ! -e "$cdrPath" ]; then

				if [ ! -e "$dmgPath" ]; then
					echo "Downloading browser ..."
					BO_downloadUrlTo "https://download.beakerbrowser.net/download/latest/osx" "$dmgPath"
				fi

				echo "Converting browser archive ..."
				/usr/bin/hdiutil convert -quiet "${dmgPath}" -format UDTO -o "${dmgPath}~"
			fi

			echo "Mounting browser archive ..."
			/usr/bin/hdiutil attach -quiet -nobrowse -noverify -noautoopen -mountpoint "$mountPath" "$cdrPath"
		fi

		echo "Extracting browser from archive ..."
		cp -Rf "${mountPath}/Beaker Browser.app/" "$appPath"
	fi

	if [ -e "$mountPath" ]; then
		/usr/bin/hdiutil detach "$mountPath"
	fi
}


function EXPORTS_open {

	PRIVATE_ensure_browser

	"$binPath"
}
