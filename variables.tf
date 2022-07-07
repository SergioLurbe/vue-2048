variable "ami" {
  description = "ami"
  type        = string
  default     = "ami-0d71ea30463e0ff8d"
}

variable "instance_type" {
  description = "ami"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "key name"
  type        = string
  default     = "key"
}

variable "vpc_security_group_ids" {
  description = "key name"
  type        = string
  default     = "sg-0f6af6ebcc5bc3e75"
}

variable "subnet_id" {
  description = "key name"
  type        = string
  default     = "subnet-06c6a408062436a05"
}