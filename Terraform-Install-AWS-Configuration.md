## LAB: Terraform Install, AWS Configuration with Terraform

This scenario shows:
- how to configure your Terraform with AWS

## Steps

- Install Terraform:
  -  https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli 

- For Windows:
 
``` 
choco install terraform
``` 

- Then, add Terraform app into the Environment Variables.

  ![image](https://user-images.githubusercontent.com/10358317/226994354-ef99ce99-c9b7-480e-ad09-36b88c6fe841.png)

- Download AWS CLI:
  - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

- For Windows: 

```
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```

  ![image](https://user-images.githubusercontent.com/10358317/226995232-d88e1533-2aa0-4d6c-b201-5ab1c58d389f.png)


- Create AWS Root Account:
  - https://repost.aws/knowledge-center/create-and-activate-aws-account 

- Create IAM Admin User:

  ![image](https://user-images.githubusercontent.com/10358317/226996766-678ae1af-1161-4d8a-9b49-4bb3915b1ba5.png)


- Create AWS Access Keys. 

- Access keys consist of two parts: 
  - an access key ID (for example, AKIAIOSFODNN7EXAMPLE),
  - a secret access key (for example, wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY). 

- You must use both the access key ID and secret access key together to authenticate your requests.

  ![image](https://user-images.githubusercontent.com/10358317/226998180-cd80ae08-a05c-479b-baad-fae9c2f094df.png)

- Configure AWS with AWS CLI (use command: aws configure):

``` 
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: eu-central-1
Default output format [None]: json
``` 

- After command, AWS creates:
  - Credentials file => C:\Users\username\.aws\credentials
  - Config file      => C:\Users\username\.aws\config

``` 
# credentials file
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
``` 

``` 
# config file
[default]
region = eu-central-1
output = json
``` 

- Now, it is your ready to run Terraform!

## Reference
- Terraform Install: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
- AWS CLI Install: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- AWS Access Keys: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
- AWS CLI Configuration: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
