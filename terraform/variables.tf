variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (2 items)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (2 items)"
  type        = list(string)
}
