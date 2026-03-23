## Overview
This repository contains my solution for creating an automated monitoring and remediation pipeline. The project is divided into three main components: a Sumo Logic query for latency detection, an AWS Lambda function for automated remediation, and Terraform configurations for infrastructure deployment.

## Assumptions & Deviations
* **Deployment Deviation (Part 2 & 3):** The instructions ask to deploy the Lambda function via the AWS Console in Part 2. However, because the function requires the EC2 instance and SNS topic to run successfully, I made the logical deviation to deploy the entire stack—including the Lambda function—at once using Terraform in Part 3.
* **Sumo Logic Log Format:** I assumed a standard JSON log format where response times are parseable to evaluate if the `/api/data` endpoint exceeds 3 seconds. 
* **EC2 and SNS Specifics:** For the Terraform setup, I used a standard Amazon Linux 2 AMI and a `t2.micro` instance to keep the demonstration simple and cost-effective.
* **IAM Permissions:** The Terraform configuration adheres to the principle of least privilege. The Lambda execution role is restricted to only allow the exact `ec2:RebootInstances`, `sns:Publish`, and CloudWatch logging actions required for the specific resources created in this stack 

## Repository Structure
* `sumo_logic_query.txt`: The query used to identify latency issues.
* `lambda_function/main.py`: The Python code that restarts the affected EC2 instance and publishes an alert notification to SNS.
* `terraform/`: The Infrastructure as Code (IaC) files used to provision the EC2 instance, SNS topic, and the Lambda function.

## Recordings
https://drive.google.com/drive/folders/1EEN-c6pr7TMzt1aLdr0RPaCn1DBLtz9b?usp=sharing