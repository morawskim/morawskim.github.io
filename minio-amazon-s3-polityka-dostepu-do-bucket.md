# minio/amazon s3 - polityka dostępu do bucket

## Polityka read only

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddPerm",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::BUCKETNAME/*"
      ]
    }
  ]
}
```

W przypadku systemu minio lista obsługiwanych warunków, operacji itp. jest dostępna pod następującym adresem https://github.com/minio/minio/blob/5fbdd70de9ec878246536dc7fd052a364db65393/docs/bucket/policy/README.md

Pole "wersja" w polityce przyjmuje jedną z dwóch wartości `2012-10-17` albo `2008-10-17`. Nie jest to pole określające rewizję naszej polityki. Określa wersję "składni" polityki. Więcej informacji https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_version.html,

## AWS-SDK-PHP

``` php
$policyJson = <<<EOS
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"PublicRead",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["arn:aws:s3:::$bucket/*"]
        }
    ]
}
EOS;

$s3Client->putBucketPolicy([
    'Bucket' => $bucket,
    'Policy' => $policyJson
]);
```