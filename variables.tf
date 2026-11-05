variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = "Trusted public IP allowed to SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "Provide a valid CIDR, such as 203.0.113.10/32."
  }
}
