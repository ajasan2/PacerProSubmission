import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client('ec2')
sns = boto3.client('sns')

def lambda_handler(event, context):
    instance_id = os.environ['INSTANCE_ID']
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']

    logger.info(f"Restarting EC2 instance: {instance_id}")
    ec2.reboot_instances(InstanceIds=[instance_id])

    message = f"Restarted EC2 instance {instance_id} due to latency alert."
    sns.publish(TopicArn=sns_topic_arn, Message=message, Subject="Latency Alert Mitigation")
    logger.info("SNS notification sent")

    return {"statusCode": 200, "body": "Success"}