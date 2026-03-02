provider "aws" {
  region = var.region_1
}

provider "aws" {
  alias  = "region2"
  region = var.region_2
}
