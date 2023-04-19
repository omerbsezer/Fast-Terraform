## SAMPLE-05: Provisioning ECR, Lambda Function and API Gateway to run Flask App Container on Lambda

This sample shows:
- how to create Flask-app-serverless image to run on Lambda,
- how to create ECR and to push image to ECR,
- how to create Lambda function, Lambda role, policy, policy-role attachment, Lambda API Gateway permission
- how to create API Gateway resource and method definition, Lambda - API Gateway connection, deploying API Gateway

There are 3 main parts:
- **0_ecr.tf**: includes private ECR code.
- **1_lambda.tf**: includes lambda function, lambda role, policy, policy-role attachment, lambda api gateway permission code.
- **2_api_gateway.tf**: includes api-gateway resource and method definition, lambda - api gateway connection, deploying api gateway code.

![image](https://user-images.githubusercontent.com/10358317/233119705-ba6544e0-dbfc-49f5-9a65-c20b82f7bae1.png)

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/lambda-container-apigateway-flaskapp

# Table of Contents
- [Flask App Docker Image Creation](#app)
- [Creating ECR (Elastic Container Repository), Pushing Image into ECR](#ecr)
- [Creating Lambda](#lambda)
- [Creating API Gateway](#apigateway)
- [Demo: Terraform Run](#run)

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

### Flask App Docker Image Creation <a name="app"></a>
- We have Flask-App to run on AWS ECS. To build image, please have a look:
  - https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/lambda-container-apigateway-flaskapp/flask-app-serverless

### Creating ECR (Elastic Container Repository), Pushing Image into ECR <a name="ecr"></a>

- Create 0_ecr.tf:
 
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Creating Elastic Container Repository for application
resource "aws_ecr_repository" "flask_app_serverless" {
  name = "flask-app-serverless"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/lambda-container-apigateway-flaskapp/ecr/0_ecr.tf

```
cd /ecr
terraform init
terraform plan
terraform apply
```

- On AWS ECR:

  ![image](https://user-images.githubusercontent.com/10358317/232346390-161b1cf6-c22c-476c-ba75-4fb2501f39ca.png)

- To see the pushing docker commands, click "View Push Commands"

```
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <UserID>.dkr.ecr.eu-central-1.amazonaws.com
docker tag flask-app-serverless:latest <UserID>.ecr.eu-central-1.amazonaws.com/flask-app-serverless:latest
docker push <UserID>.dkr.ecr.eu-central-1.amazonaws.com/flask-app-serverless:latest
```

- Image on AWS ECR:

  ![image](https://user-images.githubusercontent.com/10358317/232346479-48ecccd2-7b47-437f-a19a-dc25cbe79de0.png)

### Creating Lambda <a name="lambda"></a>

- Difference between Lambda function code and Lambda container: Defining the image on the Lambda Function.

```
# Getting data existed ECR
data "aws_ecr_repository" "flask_app_serverless" {
  name = "flask-app-serverless" 
}

# Lambda Function, in terraform ${path.module} is the current directory.
resource "aws_lambda_function" "lambda_function" {
 function_name = "Lambda-Function"
 role          = aws_iam_role.lambda_role.arn
 # tag is required, "source image ... is not valid" error will pop up
 image_uri     = "${data.aws_ecr_repository.flask_app_serverless.repository_url}:latest"    # lambda image on ECR
 package_type  = "Image"
 depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
```

![image](https://user-images.githubusercontent.com/10358317/232440083-86117379-a961-49bd-b1a6-55a4dea4685f.png)

- Create 1_lambda.tf:
 
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Create IAM Role for lambda
resource "aws_iam_role" "lambda_role" {
 name   = "aws_lambda_role"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for the lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name         = "aws_iam_policy_for_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Role - Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Getting data existed ECR
data "aws_ecr_repository" "flask_app_serverless" {
  name = "flask-app-serverless"
}

# Lambda Function, in terraform ${path.module} is the current directory.
resource "aws_lambda_function" "lambda_function" {
 function_name = "Lambda-Function"
 role          = aws_iam_role.lambda_role.arn
 # tag is required, "source image ... is not valid" error will pop up
 image_uri     = "${data.aws_ecr_repository.flask_app_serverless.repository_url}:latest"
 package_type  = "Image"
 depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

# With Lambda permission, API Gateway can invoke Lambda 
resource "aws_lambda_permission" "apigw" {
 statement_id  = "AllowAPIGatewayInvoke"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.lambda_function.function_name
 principal     = "apigateway.amazonaws.com"
 # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.
 source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/lambda-container-apigateway-flaskapp/1_lambda.tf

![image](https://user-images.githubusercontent.com/10358317/232438855-8cf0d0f9-31fd-43b7-a2c2-0ec29970c59b.png)

### Creating API Gateway <a name="apigateway"></a>

- Create 2_api_gateway.tf:
 
```
# Create API Gateway with Rest API type
resource "aws_api_gateway_rest_api" "example" {
  name        = "Serverless"
  description = "Serverless Application using Terraform"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
   path_part   = "{proxy+}"     # with proxy, this resource will match any request path
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.example.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"       # with ANY, it allows any request method to be used, all incoming requests will match this resource
   authorization = "NONE"
}

# API Gateway - Lambda Connection
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"  # With AWS_PROXY, it causes API gateway to call into the API of another AWS service
   uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# The proxy resource cannot match an empty path at the root of the API. 
# To handle that, a similar configuration must be applied to the root resource that is built in to the REST API object
resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.example.id
   resource_id   = aws_api_gateway_rest_api.example.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"  # With AWS_PROXY, it causes API gateway to call into the API of another AWS service
   uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "example" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]
   rest_api_id = aws_api_gateway_rest_api.example.id
   stage_name  = "test"
}

# Output to the URL 
output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/lambda-container-apigateway-flaskapp/2_api_gateway.tf

![image](https://user-images.githubusercontent.com/10358317/232439028-4659f2ab-27aa-4f7a-843e-355bcd53037b.png)

### Demo: Terraform Run <a name="run"></a>

- Run:
 
```
terraform init
terraform validate
terraform plan
terraform apply
```

![image](https://user-images.githubusercontent.com/10358317/232347038-4b86203f-a61c-4e31-9d3c-086b789b53e2.png)

- On AWS Lambda, new Lambda function is created:

  ![image](https://user-images.githubusercontent.com/10358317/232347067-959a2fd3-f151-4cf8-91e8-6d1f092b5062.png)
  
- This time, Container is running on the Lambda:

  ![image](https://user-images.githubusercontent.com/10358317/232347172-1f4f0a52-0dc5-406d-9ba1-babc5c71c73d.png)
  
- On AWS API-Gateway, new API is created:

  ![image](https://user-images.githubusercontent.com/10358317/232347258-ba322926-e628-4a62-9cf6-7f95c5a7c72e.png)
  
- Flask App is running in container, container is running on Lambda:

  ![image](https://user-images.githubusercontent.com/10358317/232347302-da720c4a-da30-4ea7-a567-06b2d10686c3.png)
  
- Edit posts with "Edit" button, new post with "New Post", Delete post with "Delete Post".
- Copied DB file into the "/tmp/" directory to get write permission. Lambda allows only the files under "/tmp/" to have write permission.

  ![image](https://user-images.githubusercontent.com/10358317/232347487-b61b8383-93e0-4a92-a56c-035b7ed1d0c7.png)

  ![image](https://user-images.githubusercontent.com/10358317/232347570-82dc83e3-a869-488f-ba51-2446e555b6d2.png)
  
- CloudWatch automatically logs the Lambda. If there is a debug issue, view the log groups under the Cloud Watch.

  ![image](https://user-images.githubusercontent.com/10358317/232348787-fda0e125-c6ed-4504-9e37-138501412838.png)
 
- Destroy the infra:

```
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/232347666-f2464a4d-85a7-49d2-bee4-c6062d886c22.png)

- Delete the ECR Repo:

```
cd ecr
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/232347728-ea8c3c13-4b22-4be3-bdba-b33a43023208.png)
