import os
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

asg_client = boto3.client("autoscaling", region_name=os.environ["REGION"])

ASG_NAME = os.environ["ASG_NAME"]
MAX_SIZE = 3

def lambda_handler(event, context):
    response = asg_client.describe_auto_scaling_groups(
        AutoScalingGroupNames=[ASG_NAME]
    )

    asg = response["AutoScalingGroups"][0]
    current = asg["DesiredCapacity"]

    logger.info(f"Current desired capacity: {current}")

    if current < MAX_SIZE:
        new_capacity = current + 1
        asg_client.set_desired_capacity(
            AutoScalingGroupName=ASG_NAME,
            DesiredCapacity=new_capacity,
            HonorCooldown=True
        )
        logger.info(f"Scaling out ASG to {new_capacity}")
    else:
        logger.info("Max capacity reached. No action taken.")

    return {
        "status": "ok",
        "current_capacity": current
    }
