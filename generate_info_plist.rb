#!/usr/bin/env ruby


most_recent_tag, tag_rev_count = `git tag`.
  split("\n").
  map {|tag| [tag, `git rev-list #{tag}`.count("\n")]}.
  max {|a, b| a[1] <=> b[1]}


rev_list      = `git rev-list HEAD`
head_rev_num  = rev_list.count "\n"


short_version = most_recent_tag
long_version  = most_recent_tag + ".#{head_rev_num - tag_rev_count}"
git_revision  = `git rev-parse --short=4 HEAD`.chop


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
	<string>#{short_version}</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>#{long_version}</string>
	<key>FWGitRevision</key>
	<string>#{git_revision}</string>
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
