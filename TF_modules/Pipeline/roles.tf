resource "aws_iam_role" "code_build_role" {
  name = "CBRole-${var.random_string_result}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "code_build_default_policy" {
  name = "CBDefaultPolicy-${var.random_string_result}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = [
          "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["codebuild:BatchPutCodeCoverages", "codebuild:BatchPutTestCases", "codebuild:CreateReport", "codebuild:CreateReportGroup", "codebuild:UpdateReport"]
        Resource = [
          "arn:${data.aws_partition.current.partition}:codebuild:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:report-group/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["s3:GetBucket*", "s3:GetObject*", "s3:List*", "s3:PutObject"]
        Resource = [
          "${aws_s3_bucket.code_pipeline_artifacts_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["codestar-connections:*"]
        Resource = [
          aws_codestarconnections_connection.codestarconn.arn
        ]
      },
      {
        Effect = "Allow"
        Action = ["ecr:GetAuthorizationToken", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability", "ecr:PutImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload"]
        Resource = [
          "*"
        ]
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "attach_codebuild_policy" {
  policy_arn = aws_iam_policy.code_build_default_policy.arn
  role       = aws_iam_role.code_build_role.name
}

resource "aws_iam_role" "code_pipeline_role" {
  name = "CPRole-${var.random_string_result}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "code_pipeline_default_policy" {
  name = "CPDefaultPolicy-${var.random_string_result}}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = ["${aws_s3_bucket.code_pipeline_artifacts_bucket.arn}/*"]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Resource = ["*"]
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codepipeline/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["inspector-scan:ScanSbom"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["codestar-connections:*"]
        Resource = [
          aws_codestarconnections_connection.codestarconn.arn
        ]
      },
      {
        Effect = "Allow"
        Action = ["codebuild:*"]
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:project/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "github_ecr_policy" {
  name   = "GithubEcrPolicy-${var.random_string_result}"
  policy = file("../TF_modules/Pipeline/github-ecr-interact.json")
}

resource "aws_iam_role_policy_attachment" "attach_codepipeline_policy" {
  policy_arn = aws_iam_policy.code_pipeline_default_policy.arn
  role       = aws_iam_role.code_pipeline_role.name
}

resource "aws_iam_role_policy_attachment" "attach_github_ecr_policy" {
  policy_arn = aws_iam_policy.github_ecr_policy.arn
  role       = aws_iam_role.code_pipeline_role.name
}


resource "aws_iam_role" "eks_deployment_role" {
  name        = "eks-deployment-role-${var.random_string_result}"
  description = "Role for EKS deployment"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_deployment_policy" {
  name        = "eks-deployment-policy-${var.random_string_result}"
  description = "Policy for EKS deployment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
        ]
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_eks_deployment_policy" {
  role       = aws_iam_role.eks_deployment_role.name
  policy_arn = aws_iam_policy.eks_deployment_policy.arn
}