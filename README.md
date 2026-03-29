# kmpm/container-caddy
A specialised caddy container

Repository in https://github.com/kmpm/container-caddy

## with
- https://github.com/pteich/caddy-tlsconsul
- https://github.com/caddy-dns/loopia
- https://github.com/caddy-dns/glesys



## Develop
Needs https://docs.gomplate.ca/

- To generate files `make gen`
- To build using generated files `make build`


## Using

You might have to change some settings in the host machine for UDP Buffer Sizes.
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
- `CADDY_USER` username to run the caddy process. Will be created at runtime Default `caddy`
- `CADDY_GID` id of the group. Default: `1000`
- `CADDY_UID` id of the user. Default: `1000`

See [convetions, file locations](https://caddyserver.com/docs/conventions#file-locations) for 
details of these.
- `XDG_DATA_HOME` Default: `/data`
- `XDG_CONFIG_HOME` Default: `/config` 

