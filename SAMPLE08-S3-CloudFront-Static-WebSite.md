## SAMPLE-08: Provisioning S3 and CloudFront to serve Static Web Site

This sample shows:
- how to create 

**Code:** 

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Create main.tf:
 
```

```

- Run:
 
```
terraform init
terraform validate
terraform plan
terraform apply
```
- After apply command, provisioning: 

  ![image](https://user-images.githubusercontent.com/10358317/234037248-3be6fbe0-a14f-48e9-b8cb-93d77d932da9.png)

  ![image](https://user-images.githubusercontent.com/10358317/234036899-095e2fe2-aaa4-4a41-a37c-00adc21761a2.png)

- On AWS S3:

  ![image](https://user-images.githubusercontent.com/10358317/234034144-3747b63c-2ca7-4030-9900-7d081fc2c530.png)  

  ![image](https://user-images.githubusercontent.com/10358317/234034725-085b9286-9c78-4770-a9a2-d60d5cb3e4b8.png)

- On AWS CloudFront:

  ![image](https://user-images.githubusercontent.com/10358317/234035736-38d68314-4dfd-4147-a921-9356b313b259.png)

  ![image](https://user-images.githubusercontent.com/10358317/234036235-5d41b526-8bac-41d8-87dc-cf503069e117.png)

  ![image](https://user-images.githubusercontent.com/10358317/234036566-040e8e0f-9972-487f-b533-f60058f6f7f5.png)

- On Browser, website: index.html:

  ![image](https://user-images.githubusercontent.com/10358317/234033141-ee41e25e-e5e6-4962-a21d-ed155eb25197.png)
  
  ![image](https://user-images.githubusercontent.com/10358317/234033367-79f23b83-7e7c-415b-a06f-9c73541e4660.png)

- WebSite: error.html

  ![image](https://user-images.githubusercontent.com/10358317/234033656-8a1d5671-530b-4347-968d-d8b144fda7ff.png)

- Finally, destroy infrastructure:

```
terraform destroy -auto-approve
```


## Reference
- Website Source Code: https://github.com/StartBootstrap/startbootstrap-freelancer
- https://towardsaws.com/provision-a-static-website-on-aws-s3-and-cloudfront-using-terraform-d8004a8f629a
