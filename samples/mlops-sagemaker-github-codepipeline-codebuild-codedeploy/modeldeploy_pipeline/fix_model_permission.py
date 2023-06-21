import argparse
import boto3
import json
import os
import logging
from botocore.exceptions import ClientError

# this script is a workaround to fix some permission issues with the file
# created for the model and stored in an S3 bucket

s3_client = boto3.client('s3')
sm_client = boto3.client('sagemaker')
 
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--log-level", type=str, default=os.environ.get("LOGLEVEL", "INFO").upper())
    parser.add_argument("--prod-config-file", type=str, default="prod-config-export.json")

    args, _ = parser.parse_known_args()

    # Configure logging to output the line number and message
    log_format = "%(levelname)s: [%(filename)s:%(lineno)s] %(message)s"
    logging.basicConfig(format=log_format, level=args.log_level)

    # first retrieve the name of the package that will be deployed
    model_package_name = None
    with open(args.prod_config_file, 'r') as f:
        for param in json.loads(f.read()):
            if param.get('ParameterKey') == 'ModelPackageName':
                model_package_name = param.get('ParameterValue')
    if model_package_name is None:
        raise Exception("Configuration file must include ModelPackageName parameter")
        
    # then, describe it to get the S3 URL of the model
    resp = sm_client.describe_model_package(ModelPackageName=model_package_name)
    model_data_url = resp['InferenceSpecification']['Containers'][0]['ModelDataUrl']
    _,_,bucket_name,key = model_data_url.split('/', 3)

    # finally, copy the file to override the permissions
    with open('/tmp/model.tar.gz', 'wb') as data:
        s3_client.download_fileobj(bucket_name, key, data)
    with open('/tmp/model.tar.gz', 'rb') as data:
        s3_client.upload_fileobj(data, bucket_name, key)
 
