terraform {
  required_version = ">= 0.14"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.12.0"
    }
  }
}



provider "github" {
    token = "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"
}


# Define variables
variable "repository_name" {
  type = string
}

variable "codeql_analysis" {
  type = bool
  default = true
}

# Create CodeQL analysis workflow
resource "github_actions_workflow" "codeql" {
  name = "CodeQL Analysis"
  repository = var.repository_name
  on = {
    push = {}
    pull_request = {}
  }

  # Set up CodeQL environment
  env = {
    DATABASE_URL = "https://github.com/${var.repository_name}/codeql"
    GITHUB_TOKEN = var.github_token
  }

  # Define job to run CodeQL analysis
  job {
    name = "CodeQL Analysis"
    runs_on = "ubuntu-latest"

    steps {
      # Checkout code
      name = "Checkout"
      uses = "actions/checkout@v2"

      # Set up CodeQL and analyze code
      name1 = "Run CodeQL Analysis"
      if = var.codeql_analysis
      uses1 = "github/codeql-action/analyze@v1"
    }
  }
}
