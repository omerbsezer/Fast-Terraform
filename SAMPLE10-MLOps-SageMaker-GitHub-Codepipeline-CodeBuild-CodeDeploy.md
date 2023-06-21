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
- AWS Code Pipeline for **Model Build** (CI)
  - AWS Code Pipeline (**modelbuild_ci_pipeline.tf**)
    - Stage: Source (Hook from GitHub: **modelbuild_hooks.tf**)
    - Stage: Build (**modelbuild_codebuild.tf: artifacts, environment, source (modelbuild_buildspec.yml: run build pipeline)**)
  - Sagemaker Data Pipeline (**modelbuild_pipeline project: pipeline.py**):
    - Preprocessing Step (**modelbuild_pipeline project: pipeline.py => preprocess.py**)
    - Model Training Step (**modelbuild_pipeline project: pipeline.py => XGB BuiltIn Container**)
    - Evaluation Step (**modelbuild_pipeline project: pipeline.py => evaluate.py, ConditionStep to evaluate model quality**)
    - Registering Model Step (**modelbuild_pipeline project: pipeline.py => RegisterModel**)
- AWS Code Pipeline for **Model Deploy** (CD)
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

