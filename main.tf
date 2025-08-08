# module "s3_backend" {
#   source      = "./modules/s3-backend"            # Path to the S3 module
#   bucket_name = "terraform-state-bucket-alx"      # Name of the S3 bucket
#   table_name  = "terraform-locks"                 # Name of the DynamoDB table
# }

module "vpc" {
  source              = "./modules/vpc"                                       # Path to the VPC module
  vpc_name            = "vpc-alx"                                             # Name of the VPC
  vpc_cidr_block      = "10.0.0.0/16"                                         # CIDR block for the VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]         # CIDR blocks for Public subnets
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         # CIDR blocks for Private subnets
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]            # Availability zones
}

module "ecr" {
  source                  = "./modules/ecr"       # Path to the module
  ecr_repository_name     = "ecr-alx"             # Name of the ECR repository
  scan_on_push            = true                  # Whether to scan the image for vulnerabilities on push
  force_delete            = true                  # Whether to delete the repository along with its images
  image_tag_mutability    = "MUTABLE"             # Allow/disallow overwriting tags (MUTABLE/IMMUTABLE)
  image_retention_count   = 30                    # Number of images to retain before deleting older ones
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "eks-cluster-alx"             # Cluster name
  eks_ui_username = "root"
  subnet_ids      = module.vpc.public_subnets     # Subnet IDs
  instance_type   = "t3.medium"                   # Instance type
  capacity_type   = "ON_DEMAND"                   # Instance capacity type
  ami_type        = "AL2023_x86_64_STANDARD"      # AMI type
  desired_size    = 2                             # Desired number of nodes
  max_size        = 3                             # Maximum number of nodes
  min_size        = 2                             # Minimum number of nodes
}