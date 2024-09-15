terraform {
  backend "s3" {
    bucket = "tf-join78-backend"
    key    = "ami/state"
    region = "us-east-1"
  }
}