## SAMPLE-10: Implementing MLOps Pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and AWS Sagemaker (Endpoint)

This sample shows:
- how to create MLOps Pipeline 
- how to use GitHub Hooks (Getting Source Code from Github to CodePipeline)
- how to create Build CodePipeline (Source, Build), CodeBuild (modelbuild_buildspec.yml), Deploy CodePipeline (Source, Build, DeployStaging, DeployProd), CodeBuild (modeldeploy_buildspec.yml)
- how to save the model and artifacts on S3
- how to create and test models using Notebooks

**Notes:**
- Original Source code was pulled, updated, and adapted:
  - https://github.com/aws-samples/aws-mlops-pipelines-terraform
- "Modelbuild_Pipeline" and "Modeldeploy_Pipeline" are uploaded before. After applying terraform, Webhook in the CodePipeline pulls it from GitHub to inject it into AWS.
- If you run it the first time, please open to request to AWS for the instance: "ml.m5.xlarge" ("ResourceLimitExceeded").
  - https://repost.aws/knowledge-center/sagemaker-resource-limit-exceeded-error  

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/mlops-sagemaker-github-codepipeline-codebuild-codedeploy 


**Architecture:**
- **Model Build Pipeline Source Code, modelbuild_pipeline:**  https://github.com/omerbsezer/modelbuild_pipeline 
- **Model Deploy Pipeline Source Code, modeldeploy_pipeline:** https://github.com/omerbsezer/modeldeploy_pipeline
- AWS Code Pipeline for **Model Build** (CI):
  - AWS Code Pipeline (**modelbuild_ci_pipeline.tf**)
    - Stage: Source (Hook from GitHub: **modelbuild_hooks.tf**)
    - Stage: Build (**modelbuild_codebuild.tf: artifacts, environment, source (modelbuild_buildspec.yml: run build pipeline)**)
  - Sagemaker Data Pipeline (**modelbuild_pipeline project: pipeline.py**):
    - Preprocessing Step (**modelbuild_pipeline project: pipeline.py => preprocess.py**)
    - Model Training Step (**modelbuild_pipeline project: pipeline.py => XGB BuiltIn Container**)
    - Evaluation Step (**modelbuild_pipeline project: pipeline.py => evaluate.py, ConditionStep to evaluate model quality**)
    - Registering Model Step (**modelbuild_pipeline project: pipeline.py => RegisterModel**)
- AWS Code Pipeline for **Model Deploy** (CD):
  - AWS Code Pipeline (**modeldeploy_cd_pipeline.tf**)
    - Stage: Source (Hook from GitHub: **modeldeploy_hooks.tf**)
    - Stage: Build (**modeldeploy_codebuild.tf: artifacts, environment, source (modeldeploy_buildspec.yml: run deploy pipeline => modeldeploy_pipeline project: build.py,  cloud formation to create endpoint)**)  
    - Stage: DeployStaging:
      - Action: Deploy (**Cloudformation, DeployResourcesStaging: modeldeploy_pipeline project => endpoint-config-template.yml**)
      - Action: Build (**Test Staging: modeldeploy_testbuild.tf => modeldeploy_pipeline project: test/test_buildspec.yml**)
      - Action: Approval (**Manual Approval by User**)
    - Stage: DeployProd:
      - Action: Deploy (**Cloudformation, DeployResourcesProd: modeldeploy_pipeline project => endpoint-config-template.yml**)
- Notebooks (for testing) (region: us-east-1)
  - End2end.ipynb
    - https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/mlops-sagemaker-github-codepipeline-codebuild-codedeploy/Notebooks/SageMaker_Customer_Churn_XGB_end2end.ipynb
  - Pipeline.ipynb (Sagemaker Data Pipeline)
    - https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/mlops-sagemaker-github-codepipeline-codebuild-codedeploy/Notebooks/SageMaker_Customer_Churn_XGB_Pipeline.ipynb  
    
   ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/09c0ac8a-0fe5-4877-8440-b29a22bad5cf)


### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)


## Steps
- Before running Terraform, upload "Modelbuild_Pipeline" and "Modeldeploy_Pipeline" in your GitHub account.
- Run:

```
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

- After run:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/7e2060d0-af1c-4b5e-af43-a100f163453b)

- AWS CodePipeline:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/7daef38d-2901-4087-b990-3d8b3676783e)

- ModelBuild:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/1bc7cfe7-a7b5-4155-b4a1-cbb8763a036d)

- ModelBuild Log:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/72ba0e56-a66f-4427-b35c-5680ae681fc6)
  
- AWS S3:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/5b6da22e-7ec8-4a61-821b-3ebc8d272593)

- ModelBuild was done successfully:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/9e4bad11-883e-463a-928e-d87834439e6f)

- CloudWatch to see the training accuracy:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/fa0dbc0e-e3a0-48d2-8c75-309d6dcf9e19)

- CloudWatch, Log Groups, Train Error:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/095870fb-ff0d-4ce8-bbe1-348779d9be25)
    
- ModelDeploy:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/a77c0467-3453-41dc-8f8c-c3995973bf82)

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/6fb4beb5-3d17-459f-8b31-a487b07d39f1)

- CloudFormation, stack: deploy-staging

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/205f6a3e-1e68-4fc6-895b-d30810c4e50c)

- SageMaker Dashboard, staging endpoint in service:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/4121d5c4-c2db-4a2d-8a83-c5b2183e334b)

- SageMaker, Model:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/ab3e3090-5f5b-42aa-84ff-53cc17a9a380)

- S3, Model, possible to download:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/09bdaf28-582a-45bc-b4b1-d053da0ec206)

- Try Staging Endpoint with notebook (end2end.ipynb, last cell, enter the endpointname):

```
import pandas as pd
import numpy as np
import sagemaker
import boto3
from sagemaker import get_execution_role

test_data=pd.read_csv('test.csv',header=None)
testdata1=test_data.iloc[0:1,1:]

runtime = boto3.client("sagemaker-runtime")
Endpoint_name='aws-ml-11052023-staging-0306' #<your endpoint name> # update to your own endpoint name

prediction = runtime.invoke_endpoint(
    EndpointName=Endpoint_name,
    Body=testdata1.to_csv(header=False, index=False).encode("utf-8"),
    ContentType="text/csv",
    Accept= "text/csv",
)

print(prediction["Body"].read())
```
- Endpoint returned the result:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/58d56412-b3a2-42bc-978c-4c828d3d1af8)

- Approve the Product on the CodePipeline:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/f2ee09ce-3d65-4448-9732-a5cc5a9277db)

- SageMaker Dashboard, 2 Endpoints are in-service:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/cfd146dd-cbe5-4622-946f-0ca457597e26)

- SageMaker, Prod Endpoint:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/444de0ff-f29d-42cd-b471-e17e4b13b904)

- CloudFormation:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/f803e721-2d4c-4545-a0ba-d72a260cf2e0)

- Test Prod Endpoint, returns results:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/e0ea3640-5b16-47ff-9fbf-cd1cdc81b974)

- Delete Endpoints manually, if the endpoints are in-service, you have to pay their cost:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/2d30f570-ad34-4972-bee7-05a5058f7c3b)

- Delete stacks manually in Cloudformation.
- Download artifacts on S3:

```
aws s3 sync s3://artifact-ml-11052023 C:\Users\oesezer\Desktop\aws-artifacts
```

- Downloaded to the local PC:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/d1e30b6c-7497-4913-a25b-9e1bbd92556e)

- Destroy with "terraform destroy":

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/cfcf5bc8-a3bc-4ef5-a661-ab6873aa5f65)

- Check whether all created artifacts are deleted on CodePipeline, S3, CloudFormation, SageMaker, and CloudWatch (LogGroups) or not. If still some of the artifacts are in the AWS, please delete them all. 

## References
- https://github.com/aws-samples/aws-mlops-pipelines-terraform
