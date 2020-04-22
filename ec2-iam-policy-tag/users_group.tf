resource "aws_iam_group" "developers" {
  name = "Developers"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "developers-policy-attachment-ec2restrictions" {
    group = "${aws_iam_group.developers.name}"
    policy_arn = "${aws_iam_policy.UJR_PolicyUserRestrictionEC2.arn}"
}

resource "aws_iam_group_policy_attachment" "developers-policy-attachment-readonlyaccess" {
    group = "${aws_iam_group.developers.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
resource "aws_iam_group_policy_attachment" "developers-policy-attachment-changepassword" {
    group = "${aws_iam_group.developers.name}"
    policy_arn = "${aws_iam_policy.UJR_PolicyUserChangeOwnPassword.arn}"
}

resource "aws_iam_user" "john" {
  name = "John"
  path = "/developers/"

  tags = "${local.allTags}"
}



resource "aws_iam_user_login_profile" "john_profilelogin" {
  user    = "${aws_iam_user.john.name}"
  pgp_key = "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"
}

resource "aws_iam_user_group_membership" "developers-membership-group" {
  user = "${aws_iam_user.john.name}"

  groups = [
    "${aws_iam_group.developers.name}"
  ]
}

output "john_password" {
  value = "${aws_iam_user_login_profile.john_profilelogin.encrypted_password}"
}