"# terraform-aws-vpc" 
# Terraform AWS VPC Configuration

This Terraform configuration sets up an AWS VPC with a public subnet, a private subnet, EC2 instances in each subnet, a NAT gateway, and necessary route table associations.

## Prerequisites

Before you begin, ensure that you have the following:

- Terraform installed on your machine.
- AWS credentials configured with the necessary permissions.

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/terraform-aws-vpc.git
    cd terraform-aws-vpc
    ```

2. Update the `terraform.tfvars` file with your specific values. Provide your AWS access key, secret key, and other configuration settings.

3. Initialize Terraform:

    ```bash
    terraform init
    ```

4. Review the planned changes:

    ```bash
    terraform plan
    ```

5. Apply the changes:

    ```bash
    terraform apply
    ```

    Confirm with `yes` when prompted.

6. After the deployment is complete, Terraform will output the public IP addresses of the created EC2 instances.

## Customization

Feel free to customize the Terraform variables in the `variables.tf` file to suit your specific requirements. Update security group rules, AMIs, key pairs, and other parameters as needed.

## Clean Up

To destroy the created infrastructure, run:

```bash
terraform destroy
