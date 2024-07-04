# resource "aws_iam_user" "lb" {
#     for_each = toset(["kaizen","kaizen2","kaizen3"])
#   name = each.key
#   }

#   resource "aws_iam_group" "developers" {
#   name = "developers"
#  }

#  resource "aws_iam_group_membership" "team" {
#   name = "tf-testing-group-membership"

#   users = [
#     for i in aws_iam_user.lb : i.name
#   ]

#   group = aws_iam_group.developers.name
# }