resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

module "my_ecr" {
  source        = "../TF_modules/ECR/"
  ecr_repo_name = local.ecr_repo_name # 'must satisfy regular expression '(?:[a-z0-9]+(?:[._-][a-z0-9]+)*/)*[a-z0-9]+(?:[._-][a-z0-9]+)*''
  scan_on_push  = local.scan_on_push

}

module "my_pipeline" {
  source               = "../TF_modules/Pipeline/"
  region               = local.region
    branch_name          = local.branch_name
  code_pipeline_name   = [local.web_code_pipeline_name, local.api_code_pipeline_name]
  code_build_name      = [local.web_code_build_name, local.api_code_build_name]
  full_repository_id   = local.full_repository_id # This targets you App's source repo"
  codestarconnection   = local.codestarconnection
  random_string_result = random_string.suffix.result
}

