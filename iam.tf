resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"
}

resource "aws_iam_user_policy_attachment" "dev_view_readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "dev_view_s3" {
  name        = "bedrock-dev-view-s3"
  description = "Allow put object to bedrock assets bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "dev_view_s3_attach" {
  user       = aws_iam_user.dev_view.name
  policy_arn = aws_iam_policy.dev_view_s3.arn
}

# EKS Access Entry mapping
resource "aws_eks_access_entry" "dev_view" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_user.dev_view.arn
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "dev_view_policy" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  principal_arn = aws_iam_user.dev_view.arn

  access_scope {
    type       = "namespace"
    namespaces = ["retail-app"]
  }
}