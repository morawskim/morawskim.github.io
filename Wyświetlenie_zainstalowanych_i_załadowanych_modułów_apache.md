Wyświetlenie zainstalowanych i załadowanych modułów apache
==========================================================

Za pomocą polecenie apache2ctl można wyświetlić listę załadowanych modułów.

``` bash
/usr/sbin/apache2ctl -M
Loaded Modules:
 core_module (static)
 access_compat_module (static)
 so_module (static)
 http_module (static)
 mpm_prefork_module (static)
 unixd_module (static)
 systemd_module (static)
 actions_module (shared)
 alias_module (shared)
 auth_basic_module (shared)
 authn_file_module (shared)
 authz_host_module (shared)
 authz_groupfile_module (shared)
 authz_user_module (shared)
 autoindex_module (shared)
 cgi_module (shared)
 dir_module (shared)
 env_module (shared)
 expires_module (shared)
 include_module (shared)
 log_config_module (shared)
 mime_module (shared)
 negotiation_module (shared)
 setenvif_module (shared)
 ssl_module (shared)
 userdir_module (shared)
 reqtimeout_module (shared)
 authn_core_module (shared)
 authz_core_module (shared)
 php5_module (shared)
```