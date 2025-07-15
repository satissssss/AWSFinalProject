resource "aws_ecr_repository" "default" {
  count        = length(var.ecr_repo_name)
  name         = var.ecr_repo_name[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  force_delete = true
}