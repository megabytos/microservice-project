variable "region" {
  description = "AWS region for deployment"
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "example-eks-cluster"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the node group"
  default     = "example-node-group"
}

variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  default     = "t3.medium"
}

variable "capacity_type" {
  description = "EC2 instance capacity type ON_DEMAND / SPOT"
  default     = "ON_DEMAND"
}

variable "ami_type" {
  description = "EC2 instance AMI type"
  default     = "AL2023_x86_64_STANDARD"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "eks_ui_username" {
  description = "EKS UI user name (root or user/myuser for IAM user)"
  default     = "root"
}
