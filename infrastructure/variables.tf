variable "environment" {
  description = "The environment in which the resources will be created"
  type        = string
}

variable "instance_type" {
  description = "The instance type to be used for the EC2 instance"
  type        = string
}

variable instance_count {
  description = "The number of instances to be created"
  type        = number
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to be created"
  type        = string
}
