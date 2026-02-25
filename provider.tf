provider "aws" {
  region = var.region1
  alias  = "region1"
}

provider "aws" {
  region = var.region2
  alias  = "region2"
}
