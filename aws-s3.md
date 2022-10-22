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
