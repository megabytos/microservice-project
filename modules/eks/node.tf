# IAM-роль для EC2-вузлів (Worker Nodes)
resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-eks-nodes"      # Ім'я ролі для вузлів

  assume_role_policy = jsonencode({         # Політика, що дозволяє EC2-вузлам асумувати цю IAM-роль
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Прив'язка політики AmazonEKSWorkerNodePolicy до IAM-ролі EKS Worker Nodes (дозволяє EC2-вузлам взаємодіяти з EKS API)
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

# Прив'язка політики для Amazon VPC CNI плагіну до IAM-ролі EKS Worker Nodes (надає EC2-вузлам права для роботи з Amazon VPC CNI)
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

# Прив'язка політики для читання з Amazon ECR до IAM-ролі EKS Worker Nodes (дозволяє EC2-вузлам завантажувати контейнери з Amazon ECR)
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# Створення Node Group для EKS
resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.eks.name     # Ім'я EKS-кластера
  node_group_name = "general"                 # Ім'я групи вузлів
  node_role_arn = aws_iam_role.nodes.arn      # IAM-роль для вузлів
  subnet_ids = var.subnet_ids                 # Підмережі, де будуть EC2-вузли
  capacity_type  = "ON_DEMAND"                # Тип EC2-інстансів для вузлів ON_DEMAND/ SPOT
  instance_types = ["${var.instance_type}"]   # Тип EC2-інстансів (наприклад t3.medium)

  scaling_config {                   # Конфігурація масштабування (автоскейлинга)
    desired_size = var.desired_size  # Бажана кількість вузлів
    max_size     = var.max_size      # Максимальна кількість вузлів
    min_size     = var.min_size      # Мінімальна кількість вузлів
  }

  update_config {                   # Конфігурація оновлення вузлів
    max_unavailable = 1             # Максимальна кількість вузлів, які можна оновлювати одночасно
  }

  labels = {                        # Додає мітки до вузлів які можна використовувати в nodeSelector в подах
    role = "general"                # Тег "role" зі значенням "general"
  }

  depends_on = [                     # Залежності для створення Node Group (вони мають бути створені перед створенням самої Node Group)
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  lifecycle {                                             # використовується для управління поведінкою Terraform при змінах
    ignore_changes = [scaling_config[0].desired_size]     # Ігнорує зміни в desired_size, щоб уникнути конфліктів (не буде перестворювати Node Group, якщо змінити desired_size вручну)
  }
}

