resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "github_assume_role_policy" {
    statement {
      sid = "github"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals{
        type = "Federated"
        identifiers = [aws_iam_openid_connect_provider.default.arn]
      }
      condition {
        test ="StringEquals"
        variable = "token.actions.githubusercontent.com:aud"
        values =  ["sts.amazonaws.com"]
      }
      condition {
        test ="StringEquals"
        variable = "token.actions.githubusercontent.com:sub"
        values =  ["repo:sudhakulkarni123/*:*"]
      }
    }


}
resource "aws_iam_role" "gitgub_action" {
  name               = "github-actions-oidc"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_policy.json
}
resource "aws_iam_role_policy_attachment" "gitgub_action_atch" {
    role = aws_iam_role.gitgub_action.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}