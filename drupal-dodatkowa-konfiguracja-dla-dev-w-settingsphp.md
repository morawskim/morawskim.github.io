Drupal - dodatkowa konfiguracja dla dev w settings.php
======================================================

``` php
<?php
...
// disable view cache
$conf['views_skip_cache'] = true;

// Enabling Views signatures
// With Views signatures enabled, any Views-generated query will include the name of the view and the display name in the format of view-name:display-name as a string at the end of the SELECT statement.
$conf['views_sql_signature'] = true;

// Enable theme debug mode
$conf['theme_debug'] = TRUE;

$conf['file_temporary_path'] = '/somwhere/tmp';
$conf['file_private_path'] = '/somewhere/private';

$conf['error_level'] = ERROR_REPORTING_DISPLAY_ALL;

// disable css aggregation
$conf['preprocess_css'] = FALSE;

// JS can be disabled as follows:
$conf['preprocess_js'] = FALSE;
```
