variable "project_name" {
  type        = string
  description = "Project name for tagging"
}

variable "vpc_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
}
