// Create OIDC provider to connect github actions to AWS
// and a role that github action can assume when granted permission.
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.repository_name}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-${var.github_owner}-${var.repository_name}"
  description        = "IAM role to enable GitHub OIDC access"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

// Create a policy and attach it to the github action
// role giving it permission to push images to ECR

data "aws_iam_policy_document" "github_actions_to_ecr" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.resume-app-ecr.arn]
  }
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_actions_to_ecr" {
  name        = "github-actions-ecr-${var.repository_name}"
  description = "Grant Github Actions the ability to push to ${var.repository_name} ECR repo."
  policy      = data.aws_iam_policy_document.github_actions_to_ecr.json
}

resource "aws_iam_role_policy_attachment" "github_actions_to_ecr" {
  role       = aws_iam_role.github_actions.id
  policy_arn = aws_iam_policy.github_actions_to_ecr.arn
}

// Add Github Actions Secret with role arn that GH actions will use.

resource "github_actions_secret" "aws_role_secret" {
  repository       = var.repository_name
  secret_name      = "AWS_ROLE_FOR_GITHUB"
  plaintext_value  = aws_iam_role.github_actions.arn
}

resource "github_actions_secret" "aws_ecr_repo_name" {
  repository       = var.repository_name
  secret_name      = "AWS_ECR_REPO_NAME"
  plaintext_value  = aws_ecr_repository.resume-app-ecr.name
}

