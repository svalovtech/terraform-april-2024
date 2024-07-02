resource "aws_iam_user" "lb" {
  name = "loadbalancer"
}

resource "aws_iam_user" "lb2" {
  name = "loadbalancer2"
}



resource "aws_iam_user" "lb4" {
  name = "loadbalancer4"
}
resource "aws_iam_group" "group1" {
  name = "developers"
}
resource "aws_iam_group" "group2" {
  name = "devops"
}
resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [

    aws_iam_user.lb.name,
    aws_iam_user.lb2.name,
    aws_iam_user.lb4.name,
  ]

  group = aws_iam_group.group2.name
}
resource "aws_iam_user" "hello" {
  name = "kaizen"
}



