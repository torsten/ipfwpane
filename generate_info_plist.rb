#!/usr/bin/env ruby


rev_list = `git rev-list HEAD`

rev_num = rev_list.count "\n"
long_hash = rev_list[/^.+$/]

current_commit_hash = `git rev-parse --short=5 #{long_hash}`.chop


puts %+<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>
	<key>CFBundleExecutable</key>
	<string>${EXECUTABLE_NAME}</string>
	<key>CFBundleIconFile</key>
	<string></string>
	<key>CFBundleIdentifier</key>
	<string>net.pixelshed.ipfwpane</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>ipfw Firewall</string>
	<key>CFBundlePackageType</key>
	<string>BNDL</string>
	<key>CFBundleShortVersionString</key>
	<string>r#{rev_num}</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>#{current_commit_hash}</string>
	<key>NSMainNibFile</key>
	<string>ipfwPanePref</string>
	<key>NSPrefPaneIconFile</key>
	<string>ipfwPanePref.png</string>
	<key>NSPrefPaneIconLabel</key>
	<string>ipfw Firewall</string>
	<key>NSPrincipalClass</key>
	<string>FWPrefPane</string>
</dict>
</plist>+
