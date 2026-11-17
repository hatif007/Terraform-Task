variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}
variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-08b275ac6cc5dbefb"

  }
}
