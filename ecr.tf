# Paso 1: Crear un repositorio de ECR
resource "aws_ecr_repository" "integration_ecr_repo" {
  name                 = "integration-ecr-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Paso 2: Crear una política de IAM para acceder al ECR
resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-policy"
  description = "Política de IAM para acceder al ECR desde EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = "${aws_ecr_repository.integration_ecr_repo.arn}"
      }
    ]
  })
}

# Paso 3: Asignar la política de IAM a un rol de EKS
resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
