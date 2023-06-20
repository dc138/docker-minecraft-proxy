# Docker Minecraft Proxy

A simple docker image to run a minecraft proxy in a docker container.
Downloads the desired minecraft version and flavour on startup and automatically launches it.
You must mount `/mc/proxy` as a volume in your host machine to persist data across container launches.
Supports both automatically downloading `bungeecord`, `waterfall` and `velocity` proxy jars, and using a custom proxy url link.


## Building the image

Note that you might need to change the java version used by the container to run older minecraft proxy versions.

### From source

```bash
git clone git@github.com:DarthChungo/docker-minecraft-proxy.git
cd docker-minecraft-proxy
```

```bash
docker build -t darthchungo/docker-minecraft-proxy:latest .
```

### From docker hub

Alternatively, you can download a prebuilt image from docker hub:

```bash
docker pull darthchungo/docker-minecraft-proxy:latest
```


## Running the image

Now create a directory to store the proxy data, like `data/`, for example, and run the container:

```bash
docker run -d -p 25565:25565 -v $(pwd)/data:/mc/proxy darthchungo/docker-minecraft-proxy:latest
```

The first time you run it, it will download the specified proxy jar automatically, and store its version and flavour inside a `tag.txt` file.
This way, when you restart the container, the installed proxy version can be detected, and the download skipped if the version found matches the one requested.


## Configuration

Configuration is handled through docker environment variables.
Currently used arguments:
- `PROXY_TYPE`: proxy flavour, use `bungeecord`, `waterfall` or `velocity`
- `PROXY_VERSION`:
  - `latest`: for latest version
  - `<version_number>`: for a specific version number. This is not the minecraft version; different proxy software use different versioning schemes. Use `latest` unless you need a specific proxy version.
- `PROXY_CUSTOM_URL`: a custom URL to download the proxy from.


# License

```
Docker Minecraft Proxy, a simple docker image to run a minecraft proxy.
Copyright © 2023 Antonio de Haro

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
