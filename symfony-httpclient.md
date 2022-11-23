# Symfony HttpClient

## Timeout test

``` php
/**
* Symfony does not support max_duration/timeout test
* We cannot use sleep/usleep in ResponseFactory, because Symfony simply does not check how much time pass
*
* @see https://github.com/symfony/http-client/blob/b7374c1f95714b27aeae9e4e4f573274f77a7f37/Tests/MockHttpClientTest.php#L377
* @see https://github.com/symfony/symfony/pull/32807/files
*
* @dataProvider providerTransportExceptionMessage
*/
public function testTimeout(string $transportExceptionMessage): void
{
    $mockResponse = new MockResponse('{}');
    $httpClient = new MockHttpClient($mockResponse, 'https://api.example.com');
    $httpClient = $httpClient->withOptions(['on_progress' => function (int $dlNow, int $dlSize, array $info) use ($transportExceptionMessage) {
        // based on docs, first call is after resolve domain name
        static $called = 0;
        ++$called;

        if (2 === $called) {
            throw new TransportException($transportExceptionMessage);
        }
    }]);

    // the rest of the code
}

public function providerTransportExceptionMessage(): iterable
{
    yield 'code' => ['Max duration was reached ....'];
    yield 'curl' => ['Operation timed out after'];
}
```
