# Packer templates for Amazon Elastic Compute Cloud

This project contains [Packer][] templates to help you deploy [hyperion][] on [Amazon EC2][].

## Prerequisites

* An [Amazon Web Services account](http://aws.amazon.com/)
* An [AWS Access and Secret Access Keys](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
* An [AWS EC2 Key Pairs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)


## Configure

The available variables that can be configured are:

* `access_key`: The access key used to communicate with AWS.
* `account_id`: Your AWS account ID.
* `instance_type`: The EC2 instance type to use while building the AMI (default `t2.micro`)
* `region`: The name of the region (default `eu-west-1`)
* `s3_bucket` : The name of the S3 bucket to upload the AMI
* `secret_key`: The secret key used to communicate with AWS.
* `source_ami`: The initial AMI used as a base for the newly created machine (default `Debian Jessie 64bit hvm ami`)
* `ssh_username`: The username to use in order to communicate over SSH to the running machine.
* `x509_cert_path`: The local path to a valid X509 certificate for your AWS account. This is used for bundling the AMI. This X509 certificate must be registered with your account from the security credentials page in the AWS console.
* `x509_key_path`: The local path to the private key for the X509 certificate specified by x509_cert_path.

Edit *settings.json* and setup your data.

## Build

Build the image :

	$ packer build --var-file=settings.json hyperion.json



[Packer]: https://www.packer.io/
[Amazon EC2]: https://aws.amazon.com/ec2/

[hyperion]: http://github.com/portefaix/hyperion
