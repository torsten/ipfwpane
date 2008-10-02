#!/usr/bin/env ruby


escaped_plist = File.
    read('Resources/net.pixelshed.ipfwpane.LaunchDaemon.plist').
    scan(/.{1,60}/m).
    map {|i| i.inspect }.
    join("\n")


puts %+#ifndef FW_LAUNCH_DAEMON_PLIST_H_7DRH0W6L
#define FW_LAUNCH_DAEMON_PLIST_H_7DRH0W6L

const NSString *kFWLaunchDaemonPlist =
@#{escaped_plist};

#endif /* end of include guard: FW_LAUNCH_DAEMON_PLIST_H_7DRH0W6L */
+
