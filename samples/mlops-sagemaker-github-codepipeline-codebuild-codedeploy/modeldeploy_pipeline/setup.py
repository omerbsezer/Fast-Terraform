import argparse
import json
import logging
import os
import argparse
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)
sm_client = boto3.client("sagemaker")
org_client = boto3.client("organizations")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--log-level", type=str, default=os.environ.get("LOGLEVEL", "INFO").upper())
    parser.add_argument("--sagemaker-project-id", type=str, required=True)
    parser.add_argument("--sagemaker-project-name", type=str, required=True)
    parser.add_argument("--model-package-group-name", type=str, required=True)
    parser.add_argument("--organizational-unit-staging-id", type=str, required=True)
    parser.add_argument("--organizational-unit-prod-id", type=str, required=True)

    args, _ = parser.parse_known_args()

    # Configure logging to output the line number and message
    log_format = "%(levelname)s: [%(filename)s:%(lineno)s] %(message)s"
    logging.basicConfig(format=log_format, level=args.log_level)
    model_package_group_arn = None 
    # Create model package group if necessary
    try:
        # check if the model package group exists
        resp = sm_client.describe_model_package_group(
            ModelPackageGroupName=args.model_package_group_name)
        model_package_group_arn = resp['ModelPackageGroupArn']
    except ClientError as e:
        if e.response['Error']['Code'] == 'ValidationException':
            # it doesn't exist, lets create a new one
            resp = sm_client.create_model_package_group(
                ModelPackageGroupName=args.model_package_group_name,
                ModelPackageGroupDescription="Multi account model group",
                Tags=[
                    {'Key': 'sagemaker:project-name', 'Value': args.sagemaker_project_name},
                    {'Key': 'sagemaker:project-id', 'Value': args.sagemaker_project_id},
                ]
            )
            model_package_group_arn = resp['ModelPackageGroupArn']
        else:
            raise e
    staging_ou_id = args.organizational_unit_staging_id
    prod_ou_id = args.organizational_unit_prod_id

    # finally, we need to update the model package group policy
    # Get the account principals based on staging and prod ids
    staging_accounts = [i['Id'] for i in org_client.list_accounts_for_parent(ParentId=staging_ou_id)['Accounts']]
    prod_accounts = [i['Id'] for i in org_client.list_accounts_for_parent(ParentId=prod_ou_id)['Accounts']]
    # update the policy
    sm_client.put_model_package_group_policy(
        ModelPackageGroupName=args.model_package_group_name,
        ResourcePolicy=json.dumps({
            'Version': '2012-10-17',
            'Statement': [{
                'Sid': 'Stmt1527884065456',
                'Effect': 'Allow',
                'Principal': {'AWS': ['arn:aws:iam::%s:root' % i for i in staging_accounts + prod_accounts] },
                'Action': 'sagemaker:CreateModel',
                'Resource': '%s/*' % model_package_group_arn.replace('model-package-group', 'model-package')
            }]
        })
    )
            
    
