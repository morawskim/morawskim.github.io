# guzzle3 - mock plugin

``` php
$client = new \Guzzle\Http\Client();
$client->addSubscriber(new Guzzle\Plugin\Mock\MockPlugin(array(
    new \Guzzle\Http\Message\Response(400, null, 'Error')
)));

// The following request will receive a 400 response from the plugin
$client->get('http://www.example.com/')->send();
```
