
# Note for recruiter/hiring manager:
There are a few things I could've done better, such as explicitly setting security groups to allow traffic to ALB from the CDN only, and to the instances from the ALB only. Also, I obviously would've used variables.tf to define all variables and such, but due to lack of time I had to skip it. Instead I included 2 short tfvars just for showcasing.
I tried to comment sections in the code where I could've done better.
I also would've organized the Terraform working directory with a modules/ folder and an infrastructure/ folder, and call the modules from the infrastructure folder, unless I'm using repository modules, such as for the VPC creation.
I am always happy to hear suggestions and where I could've done better! :)

## Assaf's Home Assignment

This repository contains Terraform scripts to provision an AWS infrastructure designed for a scalable application environment. The architecture focuses on security, scalability, and efficient resource management, utilizing various AWS services.

## Architecture Overview

The environment consists of:
- A Virtual Private Cloud (VPC) with two Availability Zones.
- Private subnets to host EC2 instances.
- An Auto Scaling group to dynamically adjust the number of EC2 instances based on demand.
- An Application Load Balancer (ALB) to distribute incoming traffic.
- AWS Secrets Manager to securely manage sensitive information.
- CloudFront to provide a secure entry point to the ALB.
- Amazon DynamoDB for a highly available NoSQL database.
- SMS notifications for monitoring scaling events.

## Resources Created

### 1. **VPC**
- **Resource**: `aws_vpc`
- **Description**: A VPC to isolate and secure resources within two Availability Zones.
- **CIDR Block**: Configurable based on the environment.

### 2. **Subnets**
- **Resource**: `aws_subnet`
- **Description**: Two private subnets in different Availability Zones to host EC2 instances.
- **CIDR Blocks**: Configured to allow for isolation and security.

### 3. **Security Groups**
- **Resource**: `aws_security_group`
- **Description**: 
  - **EC2 Security Group**: Allows inbound traffic on port 443 from the ALB security group.
  - **ALB Security Group**: Configured to allow traffic from CloudFront and handle incoming requests.

### 4. **EC2 Instances**
- **Resource**: `aws_launch_template`
- **Description**: A template for creating EC2 instances in the private subnets. Managed by an Auto Scaling group.
- **AMI**: Amazon Linux 2 for compatibility and security.

### 5. **Auto Scaling Group**
- **Resource**: `aws_autoscaling_group`
- **Description**: Automatically adjusts the number of EC2 instances based on demand using CloudWatch metrics.
- **Scaling Policies**: Configured to scale in/out based on CPU utilization.

### 6. **Application Load Balancer**
- **Resource**: `aws_lb`
- **Description**: Distributes incoming application traffic across multiple targets (EC2 instances).
- **Listeners**: Configured to listen on port 443 with SSL.

### 7. **CloudFront Distribution**
- **Resource**: `aws_cloudfront_distribution`
- **Description**: Serves as the entry point for users, providing a CDN to distribute content securely.
- **Origin**: Configured to route traffic to the ALB.

### 8. **DynamoDB**
- **Resource**: `aws_dynamodb_table`
- **Description**: A NoSQL database to store application data, designed for high availability and scalability.

### 9. **AWS Secrets Manager**
- **Resource**: `aws_secretsmanager_secret`
- **Description**: Stores sensitive information securely (e.g., database credentials).
- **Cross-Account Access**: Configured to allow read-only access to a specified external AWS account.

### 10. **Notifications**
- **Resource**: `aws_sns_topic`
- **Description**: Sends SMS notifications on scaling events and system stress.
- **Configuration**: Integrated with CloudWatch alarms to monitor and notify.

## Getting Started

To provision this infrastructure:

1. Clone the repository.
2. Run Terraform init
3. Run Terraform apply (could be done with flag --auto-approve)
4. Go drink coffee while this infra sets itself up!
