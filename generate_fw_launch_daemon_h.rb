#!/usr/bin/env ruby


plist_name = 'net.pixelshed.ipfwpane.LaunchDaemon.plist'

escaped_plist = File.read("Resources/#{plist_name}").
    scan(/.{1,60}/m).
    map {|i| "  #{i.inspect}" }.
    join(" \\\n")


puts %+#ifndef FW_LAUNCH_DAEMON_H_7DRH0W6L
#define FW_LAUNCH_DAEMON_H_7DRH0W6L

#define FW_LAUNCH_DAEMON_FILENAME \\
  "/Library/LaunchDaemons/#{plist_name}"

#define FW_LAUNCH_DAEMON_DATA \\
#{escaped_plist}

#endif /* end of include guard: FW_LAUNCH_DAEMON_H_7DRH0W6L */
+
