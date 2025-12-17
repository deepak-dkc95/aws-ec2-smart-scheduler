variable "project_name" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "alb_sg_id" {
  type        = string
}

variable "target_group_arn" {
  type        = string
}

variable "ami_id" {
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  default     = null
}

variable "desired_capacity" {
  type        = number
}

variable "min_size" {
  type        = number
}

variable "max_size" {
  type        = number
}
