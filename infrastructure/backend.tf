terraform {
  backend "s3" {
    bucket = "compie-technologies-assignment" # I created this bucket in my own AWS account, so you'll need to create your own.
    key    = "compie/terraform.tfstate"
    region = "us-east-1"
  }
}
