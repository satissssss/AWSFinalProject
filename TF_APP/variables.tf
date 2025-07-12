locals {
  region                 = "us-east-1"
  project_name           = "test-${random_string.suffix.result}"
  awsaccount             = "271271282869"
  ecr_repo_name          = "test-component-${random_string.suffix.result}"
  scan_on_push           = false
  branch_name            = "Mauricio"
  web_code_pipeline_name = "web-cp-${random_string.suffix.result}"
  web_code_build_name    = "web-cb-${random_string.suffix.result}"
  api_code_pipeline_name = "api-cp-${random_string.suffix.result}"
  api_code_build_name    = "api-cb-${random_string.suffix.result}"
  full_repository_id     = "satissssss/AWSFinalProject"
  codestarconnection     = "codestarconn-${random_string.suffix.result}"

}

