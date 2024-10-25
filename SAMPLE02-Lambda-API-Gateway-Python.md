## SAMPLE-02: Provisioning Lambda Function, API Gateway and Reaching HTML Page in Python Code From Browser

This sample shows:
- how to create Lambda function with Python code,
- how to create Lambda Role, Policy, Policy-Role attachment, Lambda API-gateway permission, uploading code,
- how to create API-gateway resource and method definition, Lambda-API-gateway connection, deploying API-gateway,
- details on AWS Lambda, API-Gateway, IAM

![3 Lambda-TF](https://github.com/user-attachments/assets/554cfb9b-44a3-4eb0-b278-a3ae5c25ffbe)


There are 3 main parts:
- lambda.tf: It includes lambda function, lambda role, policy, policy-role attachment, lambda api gateway permission, zipping code
- api-gateway.tf: It includes api-gateway resource and method definition, lambda - api gateway connection, deploying api gateway, api-gateway deployment URL as output
- code/main.py: It includes basic lambda handler with basic HTML code, and REST API response. 

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/lambda-role-policy-apigateway-python

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Create lambda.tf:
  - **Terraform Configuration:** Specifies the AWS provider version and Terraform version.
  - **IAM Role and Policy:** Creates an IAM role for the Lambda function and attaches a policy that allows the Lambda function to write logs to CloudWatch.
  - **Zipping Lambda Code:** Prepares the Python code by zipping it into a format that Lambda can execute.
  - **Lambda Function:** Creates a Lambda function using the specified IAM role, code, and runtime.
  - **API Gateway Integration:** Grants API Gateway permission to invoke the Lambda function.
 
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

# Zipping the code, lambda wants the code as zip file
data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "${path.module}/code/"
 output_path = "${path.module}/code/main.zip"
}

# Lambda Function, in terraform ${path.module} is the current directory.
resource "aws_lambda_function" "lambda_function" {
 filename                       = "${path.module}/code/main.zip"
 function_name                  = "Lambda-Function"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "main.lambda_handler"
 runtime                        = "python3.8"
 depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
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

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/lambda-role-policy-apigateway-python/lambda.tf

![image](https://user-images.githubusercontent.com/10358317/230722794-2ba9d223-90f3-4634-8fba-d5290ecf6e8a.png)

- Create api-gateway.tf: 
  - **Proxy Usage:** The {proxy+} path is used to dynamically route all requests to the Lambda function, eliminating the need to define individual paths and methods.
  - **Flexibility:** The ANY method allows all HTTP methods, making the API flexible.
  - **AWS_PROXY Integration:** Simplifies the interaction between API Gateway and Lambda by passing the entire request data to Lambda, allowing it to process dynamically.
 
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

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/lambda-role-policy-apigateway-python/api-gateway.tf

![image](https://user-images.githubusercontent.com/10358317/230722822-b8352e6e-6ebf-4dec-ab36-0f5d7bcfe914.png)


- Create main.py under code directory:

```
def lambda_handler(event, context):
   content = """
   <html>
   <h1> Hello Website running on Lambda! Deployed via Terraform </h1>
   </html>
   """
   response ={
     "statusCode": 200,
     "body": content,
     "headers": {"Content-Type": "text/html",}, 
   }
   return response
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/lambda-role-policy-apigateway-python/code/main.py

![image](https://user-images.githubusercontent.com/10358317/230722767-2f89b91b-eab3-4348-b405-7ca773bee803.png)

- Run init, validate command:

``` 
terraform init
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/230722951-8516b9fd-2b03-4391-b91f-a338c207b669.png)

- Run plan, apply command:

``` 
terraform plan   # for dry-run
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/230723022-f5443b26-7b50-4834-ad2a-a8f1f277ecbb.png)

![image](https://user-images.githubusercontent.com/10358317/230723143-a4cd31a1-a48a-4ed9-92aa-1ddc4ecafb2a.png)

- On AWS Lambda:

![image](https://user-images.githubusercontent.com/10358317/230723176-fe26cd48-b8cc-463f-9bba-cb8573514e64.png)

![image](https://user-images.githubusercontent.com/10358317/230723214-0e056c50-567e-4cca-bc67-73328301b24c.png)

- Create a test by clicking "Test" for lambda function:

![image](https://user-images.githubusercontent.com/10358317/230723292-5496d0f0-977d-46e4-96ee-239808e56284.png)

- Status code 200, OK is returned successfully:

![image](https://user-images.githubusercontent.com/10358317/230723342-bb606c2f-b9d6-47d0-93b6-e935e00481e1.png)

- Execution Role is created, seen on Lambda

![image](https://user-images.githubusercontent.com/10358317/230723943-f9cafb0e-a03a-4c40-a55e-792c5416c8ed.png)

- Role on IAM:

![image](https://user-images.githubusercontent.com/10358317/230724180-0829397f-fc53-4199-8eb5-8c206237d771.png)

- Policy on IAM:

![image](https://user-images.githubusercontent.com/10358317/230724019-dfd4936c-85a0-42a3-b3f3-fcae018ca8e6.png)

- On AWS Lambda: With Lambda permission, API Gateway can invoke Lambda 

![image](https://user-images.githubusercontent.com/10358317/230724344-09c46001-af57-4637-ab46-3df38cfd5b27.png)


- Lambda is triggered by API-Gateway:

![image](https://user-images.githubusercontent.com/10358317/230723832-95739c09-ec36-4eb6-b1a4-5acbd675ea27.png)

- On AWS API-Gateway:

![image](https://user-images.githubusercontent.com/10358317/230723491-4f377afc-8fc9-4ab9-ba99-41970e205207.png)

![image](https://user-images.githubusercontent.com/10358317/230723560-b5f814e0-c1e2-4961-99e1-4f846de3797e.png)

- By clicking "Test" to test api-gateway

![image](https://user-images.githubusercontent.com/10358317/230723599-0a7f38e9-2f64-4dde-8da2-e19c3ceccd7c.png)

![image](https://user-images.githubusercontent.com/10358317/230723628-76d57abe-4943-4876-bbaa-b2e1021476e5.png)

- HTML page that runs on Lambda Function using API-Gateway can be reached. With API-Gateway, lambda function gets DNS and traffic from internet comes to the Lambda function. 

![image](https://user-images.githubusercontent.com/10358317/230723675-38fa5f25-c7ef-46e9-8eba-5e5691b47c88.png)


- Run destroy command:

``` 
terraform destroy
``` 

![image](https://user-images.githubusercontent.com/10358317/230724579-86f8228a-efcb-4ae8-bcc3-009fa54a5d14.png)

- On AWS Lambda, function is deleted:

![image](https://user-images.githubusercontent.com/10358317/230724707-4e5070cf-a801-4b3e-9aa7-560b279a48a5.png)

## References
- https://www.tecracer.com/blog/2021/08/iam-what-happens-when-you-assume-a-role.html
- https://medium.com/paul-zhao-projects/serverless-applications-with-aws-lambda-and-api-gateway-using-terraform-37d3de435d21
- https://github.com/rahulwagh/Terraform-Topics/tree/master/aws-lambda
