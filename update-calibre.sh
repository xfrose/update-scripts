#!/usr/bin/env bash
#export http_proxy=http://127.0.0.1:10808
#export https_proxy=$http_proxy
#export HTTP_PROXY=$http_proxy
#export HTTPS_PROXY=$http_proxy

# Get the local calibre version
local_version=$(calibre --version | cut -d ' ' -f 3 | sed 's/)//')

# Get the remote calibre version
remote_version=$(curl -s https://raw.githubusercontent.com/kovidgoyal/calibre/master/Changelog.txt | sed -n 's/^{{{ \([0-9]*\.[0-9]*[1-9]\)\.0 .*$/\1/p' | head -n 1)

# Check if curl command succeeded
if [ $? -ne 0 ]; then
  echo "Failed to retrieve remote version. Exiting..."
  exit 1
fi

# Check if the remote_version is empty (indicating a problem)
if [ -z "$remote_version" ]; then
  echo "Failed to retrieve remote version. Exiting..."
  exit 1
fi

# Compare the versions
if [ "$local_version" == "$remote_version" ]; then
  echo "You have the latest calibre version: $local_version"
else
  echo "Your calibre version is outdated: $local_version"
  echo "The latest calibre version is: $remote_version"
  echo "Updating calibre..."

# Update calibre using the official install script
  sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
  echo "Calibre updated successfully!"
fi

