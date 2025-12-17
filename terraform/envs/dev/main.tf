module "vpc" {
  source = "../../modules/vpc"

  project_name          = "aws-smart-scheduler"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
  azs                   = ["ap-south-1a", "ap-south-1b"]
}

module "alb" {
  source = "../../modules/alb"

  project_name       = "aws-smart-scheduler"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "asg" {
  source = "../../modules/asg"

  project_name        = "aws-smart-scheduler"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  alb_sg_id           = module.alb.alb_sg_id
  target_group_arn    = module.alb.target_group_arn

  ami_id              = "ami-0f5ee92e2d63afc18" # Example Amazon Linux / Ubuntu
  instance_type       = "t3.micro"

  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
}

module "lambda" {
  source = "../../modules/lambda"

  project_name = "aws-smart-scheduler"
  asg_name     = module.asg.asg_name
  region       = "ap-south-1"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "cpu-high-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 60

  dimensions = {
    AutoScalingGroupName = module.asg.asg_name
  }

  alarm_actions = [module.lambda.lambda_arn]
}
