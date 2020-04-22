resource "aws_iam_policy" "UJR_SSMManagedInstanceCore" {
  name        = "UJR_SSMManagedInstanceCore"
  description = "The policy for Amazon EC2 Role to enable AWS Systems Manager service core functionality."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "UJR_PolicyUserRestrictionEC2" {
  name        = "UJR_PolicyUserRestrictionEC2"
  description = "The policy to restrict Users to operate only over Develop EC2 Instances Environment"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Environment": "DEV"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:StartSession"
      ],
      "Resource": [
        "arn:aws:ec2:eu-central-1:*:instance/*"
      ],
      "Condition": {
        "StringLike": {
          "ssm:resourceTag/Environment": "DEV"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:TerminateSession"
      ],
      "Resource": [
        "arn:aws:ssm:*:*:session/$${aws:username}-*"
      ]
    }
  ]
}
EOF
}


# "arn:aws:iam::*:user/developers/$${aws.username}"   --> Filter not working
resource "aws_iam_policy" "UJR_PolicyUserChangeOwnPassword" {
  name = "UJR_PolicyUserChangeOwnPassword"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:ChangePassword"
      ],
      "Resource": [
        "*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:GetAccountPasswordPolicy"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "UJR_SSMRoleForEC2Instances" {
  name = "UJR_SSMRoleForEC2Instances"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = "${local.allTags}"
}

resource "aws_iam_role_policy_attachment" "attach_role_policy_ujr_ssm" {
  role = "${aws_iam_role.UJR_SSMRoleForEC2Instances.name}"
  policy_arn = "${aws_iam_policy.UJR_SSMManagedInstanceCore.arn}"
}

resource "aws_iam_instance_profile" "UJR_SSMRoleForEC2Instances" {
    name ="UJR_SSMRoleForEC2Instances"
    role = "${aws_iam_role.UJR_SSMRoleForEC2Instances.name}"
}