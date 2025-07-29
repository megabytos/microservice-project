# IAM-роль для EKS-кластера, яка дозволяє сервісу EKS взаємодіяти з іншими сервісами AWS
resource "aws_iam_role" "eks" {
  name = "${var.cluster_name}-eks-cluster"      # Ім'я IAM-ролі для кластера EKS

  assume_role_policy = jsonencode({             # Політика, яка дозволяє сервісу EKS «асумувати» цю IAM-роль
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Прив'язка політики AmazonEKSClusterPolicy до IAM-ролі EKS-кластера
resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"   # ARN політики AWS, яка забезпечує основні дозволи для керування EKS-кластером
  role = aws_iam_role.eks.name                                    # IAM-роль, до якої прив'язується політика
}

# Створення EKS-кластера
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name        # Назва кластера
  role_arn = aws_iam_role.eks.arn    # ARN IAM-ролі, яка потрібна для керування кластером

  vpc_config {                       # Налаштування мережі (VPC)
    endpoint_private_access = true   # Дозволяє доступ до API-сервера через приватну мережу (VPC)
    endpoint_public_access  = true   # Дозволяє  публічний доступ до API-сервера через інтернет
    subnet_ids = var.subnet_ids      # Список публічних та приватних підмереж у VPC, де буде працювати EKS
  }

  access_config {                                        # Налаштування доступу до EKS-кластера
    authentication_mode                         = "API"  # Додає режим автентифікації через API
    bootstrap_cluster_creator_admin_permissions = true   # Надає адміністративні права користувачу, який створив кластер (дозволяє автоматичний доступ адміністраторам)
  }

  depends_on = [aws_iam_role_policy_attachment.eks]    # Залежність від IAM-політики для ролі EKS (IAM-роль та її політика мають бути створені перед створенням самого EKS-кластера)
}
