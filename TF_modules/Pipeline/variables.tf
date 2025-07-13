variable "region" {
  type        = string
  description = "default region"
}

variable "full_repository_id" {
  description = "The full repository ID to use with your CodeConnections connection."
  type        = string
}

variable "codestarconnection" {
  description = "The AWS Developer Tools GitHub App connection to your personal repo"
  type        = string
}

variable "branch_name" {
  description = "The branch name to use with your CodeConnections connection."
  type        = string
}

variable "code_pipeline_name" {
  description = "The CodePipeline pipeline name that will build your python source project."
  type        = list(string)

}

variable "code_build_name" {
  description = "The CodeBuild build name that will build your python source project."
  type        = list(string)

}

variable "ci_code_build_spec" {
  description = "The CodeBuild project build spec python configuration"
  type        = string
  default     = <<EOL
version: 0.2

phases:
  build:
    commands:
      - echo "Install python dependencies"
      - python -m pip install --upgrade pip
      - if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
EOL
}

variable "retention_policy" {
  description = "Define if you'd like the resource retained or deleted when the CloudFormation stack is deleted."
  type        = string
  default     = "Delete"
  validation {
    condition     = contains(["Delete", "Retain"], var.retention_policy)
    error_message = "Must be Delete or Retain"
  }
}

variable "random_string_result" {
  description = "random string result"
  type        = string
}