# AWS VPC Terraform Configuration

## Overview
This Terraform configuration sets up a basic AWS Virtual Private Cloud (VPC) infrastructure, including:
- A VPC with a specified CIDR block.
- A public subnet.
- An Internet Gateway (IGW) for internet access.
- A Route Table with appropriate routing rules.
- A Security Group to allow inbound HTTP and SSH traffic.

## Prerequisites
Before using this Terraform configuration, ensure you have:
- An AWS account.
- Terraform installed ([Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)).
- AWS credentials (Access Key and Secret Key).

## Configuration
This Terraform script uses variables for AWS region, access keys, and availability zone. Define these variables in a `terraform.tfvars` file.

### Required Variables

create a `terraform.tfvars` file:
```hcl
aws_region = "us-east-1"
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"
aws_az = "us-east-1a"
```

## Usage

### Initialize Terraform
Run the following command to initialize Terraform and download required providers:
```sh
terraform init
```

### Plan the Deployment
Check the planned execution without applying changes:
```sh
terraform plan
```

### Apply the Configuration
Deploy the resources to AWS:
```sh
terraform apply
```
Type `yes` when prompted to confirm the deployment.

### Destroy Resources
To remove all resources created by this configuration:
```sh
terraform destroy
```

## Resources Created
- **VPC** (`aws_vpc.my-vpc`)
- **Subnet** (`aws_subnet.subnet-1`)
- **Internet Gateway** (`aws_internet_gateway.gw`)
- **Route Table** (`aws_route_table.my-vpc-public-rtb`)
- **Route Table Association** (`aws_route_table_association.a`)
- **Security Group** (`aws_security_group.allow_def`)
  - Allows HTTP (port 80) and SSH (port 22) inbound traffic.
  - Allows all outbound traffic.

## Notes
- The security group allows SSH access from any IP (`0.0.0.0/0`). Consider restricting this to specific IP ranges for better security.

## Author
Ofor David Tochukwu

