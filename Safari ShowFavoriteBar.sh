#!/bin/bash

# Created By Jonathan Synotte
# Modified October 24, 2024
version="1.0.0"

# get the currently logged in user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# global check if there is a user logged in
if [ -z "$currentUser" -o "$currentUser" = "loginwindow" ]; then
	echo "no user logged in, cannot proceed"
	exit 1
fi
# now we know a user is logged in

# get the current user's UID
uid=$(id -u "$currentUser")

# convenience function to run a command as the current user
# usage:
#   runAsUser command arguments...
runAsUser() {  
	if [ "$currentUser" != "loginwindow" ]; then
		launchctl asuser "$uid" sudo -u "$currentUser" "$@"
	else
		echo "no user logged in"
		# uncomment the exit command
		# to make the function exit with an error when no user is logged in
		exit 1
	fi
}

# Run as user to modify Safari plist for showing the favorite bar
runAsUser defaults write /Users/$currentUser/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist ShowFavoritesBar-v2 -bool true

echo "Change the default value to show the Safari Favorite Bar for $currentUser"
