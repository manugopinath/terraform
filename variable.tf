variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

# Ubuntu Precise 14.04 LTS (x64)
variable "aws_amis" {
default  = {
    "eu-west-1" = "ami-3b742d48"
    "us-east-1" = "ami-7e8fb669"
    "us-west-1" = "ami-0c0a5d6c"
    "us-west-2" = "ami-cbd57cab"
  }
}

variable "count" {
default = 1
  }
