variable "project_name" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "region" {
  type = string
}

variable "lambda_handler" {
  type    = string
  default = "autoscale_handler.lambda_handler"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.11"
}
