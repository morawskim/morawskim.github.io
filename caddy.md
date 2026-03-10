# caddy

## Path reverse proxy

```
:80
log
handle_path /_mitmweb/* {
    reverse_proxy http://mitmweb:80 {
        header_up Host "127.0.0.1:80"
        header_up -X-Forwarded-*
    }
}
```
