Wordpress - wygenerowanie nowego hasła
======================================

W przypadku standardowej instalacji Wordpressa, nowe hasło można wygenerować wywołując funkcję wp_hash_password.

``` php
echo wp_hash_password('hasloooooooooooo');
```

Niemniej jednak ta funkcja może być nadpisywana przez pluginy, które implementują własny mechanizm autoryzacji.

Więcej informacji <https://codex.wordpress.org/Function_Reference/wp_hash_password>