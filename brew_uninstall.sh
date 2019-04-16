#!/bin/bash
brew services stop mariadb
sudo brew services stop dnsmasq
sudo apachectl -k stop
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
sudo rm -rf /usr/local/.com.apple.installer.keep
sudo rm -rf /usr/local/bin/
sudo rm -rf /usr/local/etc/
sudo rm -rf /usr/local/share/
sudo rm -rf /usr/local/var/

#Desactivate daemons
sudo launchctl unload -w /Library/LaunchDaemons/pete.mxcl.httpd.plist 2>/dev/null
sudo rm -rf /Library/LaunchDaemons/pete.mxcl.httpd.plist
sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
sudo apachectl start

#Delete WordpressPete App
sudo rm -rf /Applications/WordpressPete.app
username=`id -un`
rm -rf /Users/$username/Sites/Pete
rm -rf /Users/$username/wwwlog/Pete
