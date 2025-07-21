# HW 5 - Terraform 
This project provide basic AWS infrastructure using Terraform with modular structure and remote state backend.

## Project Structure

```
├── backend.tf             # S3 + DynamoDB backend configuration
├── main.tf                # Main entry point to invoke modules
├── modules/               # Terraform modules
│ ├── s3-backend/          # Remote state backend (S3 + DynamoDB) module
│ ├── vpc/                 # Network infrastructure (VPC) module
│ └── ecr/                 # Docker image repository (ECR) module
```



## Cloning the Repository
1. Clone the repo
```shell
git clone <repository-url>
```

2. Checkout branch `lesson-5`
```shell
git checkout lesson-5
```

## AWS Configuration

```bash
aws configure
# Enter your AWS credentials
```
---

## Preparing the Backend (S3 + DynamoDB)

Before you start, you need to create the backend to store the Terraform state (terraform.tfstate) and to enable locking to prevent conflicts during team collaboration.
To do this:

1. Navigate to the `s3-backend` folder:

```bash
cd s3-backend
```

2. Initialize Terraform, review the plan, and create the backend resources:

```bash
terraform init
terraform plan
terraform apply
```

This will create:

- An S3 bucket to store the state
- A DynamoDB table for state locking

---

## Creating the Infrastructure

After the backend is created, return to the root folder with the main Terraform configuration and run the standard commands to create the infrastructure.

It is recommended to comment out the s3_backend creation block in main.tf and the output data of this module in outputs.tf before this.

Initialize Terraform:

```bash
terraform init
```

Review the changes:

```bash
terraform plan
```

Apply the changes:

```bash
terraform apply
```

View the outputs:

```bash
terraform output
```
---
## Destroying the Infrastructure

If you need to remove the created resources, run:

```bash
terraform destroy
```
To completely clean up cached files, you can run:

```bash
rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
```