# kmpm/container-caddy
A specialised caddy container

Repository in https://github.com/kmpm/container-caddy

## with
- https://github.com/pteich/caddy-tlsconsul
- https://github.com/caddy-dns/loopia
- https://github.com/caddy-dns/glesys



## Develop
- Needs https://docs.gomplate.ca/


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
