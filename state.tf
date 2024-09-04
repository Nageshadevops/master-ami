terraform {
  backend "s3" {
    bucket = "tf-join-backend"
    key    = "ami/state"
    region = "us-east-1"
  }
}