# Kubernetes troubleshooting

## PHP, service account i token

W logach aplikacji PHP, która działała w klastrze Kubernetes i korzystała z API k8s pojawiał się błąd:

> Warning: file_get_contents(/var/run/secrets/eks.amazonaws.com/serviceaccount/token): failed to open stream: No such file or directory

Token JWT był montowany i odświeżany automatycznie przez Kubernetes.
Istnieje kilka zgłoszeń tego problemu:
* [Intermittent failure while loading token in EKS with service accounts #900](https://github.com/async-aws/aws/issues/900)
* [Token file not found temporarily after refresh on Kubernetes #2014](https://github.com/aws/aws-sdk-php/issues/2014)
* [Clear expired web id token path cache](https://github.com/aws/aws-sdk-php/pull/2043)

Problemem okazał się cache PHP, który buforuje informacje zwracane o plikach.
Za pomocą funkcji [clearstatcache](clearstatcache) możemy wyczyścić ten cache i tym samym pozbyć się problemu.

Przykładowe rozwiązanie:

```
$token = @file_get_contents($tokenFile);
if (false !== $token) {
    return $token;
}
$tokenDir = \dirname($tokenFile);
$tokenLink = readlink($tokenFile);
clearstatcache(true, $tokenDir . \DIRECTORY_SEPARATOR . $tokenLink);
clearstatcache(true, $tokenDir . \DIRECTORY_SEPARATOR . \dirname($tokenLink));
clearstatcache(true, $tokenFile);
if (false === $token = @file_get_contents($tokenFile)) {
    throw new \RuntimeException('Cannot read token');
}

```
