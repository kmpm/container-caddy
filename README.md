# kmpm/container-caddy
A specialised caddy container. 

Repository in https://github.com/kmpm/container-caddy.

Also contains both `wget` and `curl` for possible health check using docker/compose.


## with
The following caddy components are added to the default.

- [Loopia DNS-01 support](https://github.com/caddy-dns/loopia)
- [Glesys DNS-01 support](https://github.com/caddy-dns/glesys)




## Develop
Needs https://docs.gomplate.ca/

```shell
# install gomplate
go install github.com/hairyhenderson/gomplate/v5/cmd/gomplate@latest
gomplate --help

# modify the templates, files etc

# generate files from templates
make gen

# make images
make build

# do local testing and repeat until happy

# push to github
# generate release in github.
```



- To generate files `make gen`
- To build using generated files `make build`


## Using

The entrypoint starts using `root` as user but creates and switches to defined user when running caddy.
If the, by environment variables, given UID or GID exists (might happen if <1000) then
the existing corresponding user or group will be used instead of the configured.

You might have to change some settings in the host machine for UDP Buffer Sizes for
optimal performance. Please read
https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes

```bash
sysctl -w net.core.rmem_max=7500000
sysctl -w net.core.wmem_max=7500000
```

To persist these settings you could add the values to `/etc/sysctl.conf`

```
...
net.core.rmem_max = 7500000
net.core.wmem_max = 7500000

```

### Environment variables

- `CADDY_CONFIG` path to config file. Default: `/etc/caddy/Caddyfile`
- `CADDY_ENVFILE` if the file exists caddy will load it as environment variables. Default: `/etc/caddy/env`
- `CADDY_ADAPTER` what kind of adapter needed to read CADDY_CONFIG. Default: `caddyfile`
- `CADDY_USER` username to run the caddy process. Will be created at runtime if `CADDY_UID` does not exist. Default `caddy`
- `CADDY_GROUP` group to run the caddy process. Will be created at runtime if `CADDY_GID` does not exist. Default `caddy`
- `CADDY_GID` id of the group. Default: `1000`
- `CADDY_UID` id of the user. Default: `1000`
- `CADDY_FMT` if set to `True` so will `caddy fmt --overwrite` be used on the `CADDY_CONFIG` 


See [convetions, file locations](https://caddyserver.com/docs/conventions#file-locations) for 
details of these.
- `XDG_DATA_HOME` Default: `/data`
- `XDG_CONFIG_HOME` Default: `/config` 

