#!/bin/sh

#
# Docker Minecraft Proxy, a simple docker image to run a minecraft proxy.
# Copyright © 2023 Antonio de Haro
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Inputs
# $1: minecraft flavour ("bungeecord", "waterfall", "velocity")
# $2: minecraft version ("<version>", "latest", ...)
# Outputs
# url: download url
# version: actual proxy version (versioning schemes vary depending on the proxy used)
get_version_info() {
  case $1 in
    "bungeecord")
      if [ "$2" = "latest" ]; then
        version=$(wget -q "https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/buildNumber" -O-)

      elif $(echo $2 | grep -Eq "[0-9]+"); then
        version=$2
      fi

      url="https://ci.md-5.net/job/BungeeCord/$version/artifact/bootstrap/target/BungeeCord.jar";;

    "waterfall")
      if [ "$2" = "latest" ]; then
        version=$(wget -q "https://api.papermc.io/v2/projects/waterfall/" -O- | jq -r ".versions | last")

      elif $(echo $2 | grep -Eq "[0-9]+\.[0-9]+"); then
        version=$2
      fi

      waterfall_version=$(wget -q "https://api.papermc.io/v2/projects/waterfall/versions/$version/" -O- | jq -r ".builds | last")
      url="https://api.papermc.io/v2/projects/waterfall/versions/$version/builds/$waterfall_version/downloads/waterfall-$version-$waterfall_version.jar";;

    "velocity")
      if [ "$2" = "latest" ]; then
        version=$(wget -q "https://api.papermc.io/v2/projects/velocity/" -O- | jq -r ".versions | last")

      elif $(echo $2 | grep -Eq "[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z]+)?"); then
        version=$2
      fi

      velocity_version=$(wget -q "https://api.papermc.io/v2/projects/velocity/versions/$version/" -O- | jq -r ".builds | last")
      url="https://api.papermc.io/v2/projects/velocity/versions/$version/builds/$velocity_version/downloads/velocity-$version-$velocity_version.jar";;
  esac
}

cd /mc/
echo "Copying files..."

if [ ! -z $CUSTOM_SERVER_URL ]; then
  url=$CUSTOM_SERVER_URL
  flavour=$SERVER_VERSION
  version="custom"

  echo Using \"$CUSTOM_SERVER_URL\" as custom proxy url

else
  get_version_info $SERVER_TYPE $SERVER_VERSION
  flavour=$SERVER_TYPE

  echo Using \"$url\" as $SERVER_TYPE proxy url
fi

tag="$url $version $flavour"

if [ -e proxy/tag.txt ] && [ -e proxy/proxy.jar ] && grep -q "$tag" proxy/tag.txt; then
  echo "Using existing proxy jar"

else
  echo "Downloading proxy jar for the first time"

  rm -rvf /mc/proxy/libraries
  rm -rvf /mc/proxy/proxy.jar

  echo Downloading proxy...
  wget -q $url -O proxy/proxy.jar
fi

cd /mc/proxy/
echo $tag > tag.txt

java $JVM_FLAGS -jar proxy.jar
