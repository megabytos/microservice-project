output "s3_bucket_name" {
  description = "Name of the S3 bucket for states"
  value       = module.s3_backend.s3_bucket_name
}

output "s3_bucket_url" {
  description = "URL of the S3 bucket for states"
  value       = module.s3_backend.s3_bucket_url
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = module.ecr.repository_name
}

output "repository_url" {
  description = "The URL of the ECR repository (for push images)"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = module.ecr.repository_arn
}
