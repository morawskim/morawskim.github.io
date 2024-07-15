# AWS S3

## Porady

* W S3 możemy wymagać MFA przy kasowania plików. Najczęściej dotyczy to bucketa przechowującego ważne dane np. logi. [Configuring MFA delete](https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiFactorAuthenticationDelete.html)

## PutObject

```
$response = $s3Client->putObject([
    'Bucket' => 'bucketname',
    'Key' => '/path/subpath/file',
    'SourceFile' => '/tmp/dc76d4ed90437c597505b21fdad2fc50.jpg',

    'ACL' => 'public-read',
    // Enable server side encyption, encryption keys managed by AWS
    'ServerSideEncryption' => 'AES256',
    // set storage class
    'StorageClass' => 'STANDARD_IA',
    'CacheControl' => 'public, max-age=3600',
    // set tags for object, value should be urlencoded
    'Tagging' => 'foo=bar&tag=value',
]);

$response->get('ObjectURL');
```

Do weryfikacji ustawionych parametrów możemy skorzystać z poniższych poleceń:

```
aws s3api head-object --bucket <bucketname> --key <aws-s3-key>
aws s3api get-object-tagging --bucket <bucketname> --key <aws-s3-key>
aws s3api get-object-acl --bucket <bucketname> --key <aws-s3-key>
```

### Golang i unseekable streaming input

Podczas wywoływania akcji PutObject otrzymałem błąd:
"operation error S3: PutObject, failed to compute payload hash: failed to seek body to start, request stream is not seekable".

[Błąd ten był zgłoszony w bibliotece](https://github.com/aws/aws-sdk-go-v2/issues/1108).
[W dokumentacji](https://aws.github.io/aws-sdk-go-v2/docs/sdk-utilities/s3/#unseekable-streaming-input) mamy także informację o tym problemie i rozwiązanie (jeśli nie możemy korzystać z interfejsu `io.ReadSeekCloser`).

```
resp, err := client.PutObject(context.TODO(), &s3.PutObjectInput{
    Bucket: &bucketName,
    Key: &objectName,
    Body: bytes.NewBuffer([]byte(`example object!`)),
    ContentLength: 15, // length of body
}, s3.WithAPIOptions(
    v4.SwapComputePayloadSHA256ForUnsignedPayloadMiddleware,
))
```
