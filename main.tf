terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
	  profiles = {
		default = "default"
	  }
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_vpc" "vpc_project" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name              = "task_vpc"
    Account           = "VPC in Account: ${data.aws_caller_identity.current.account_id}"
    Region            = "VPC in Region: ${data.aws_region.current.name}"
    RegionDescription = "Region Description: ${data.aws_region.current.name}"
  }
}

resource "aws_subnet" "vpc_subnet_1" {
  vpc_id              = aws_vpc.vpc_project.id
  availability_zone   = data.aws_availability_zones.available.names[0]
  cidr_block          = "192.168.1.0/24"
  tags = {
    Name              = "Subnet-1 ${data.aws_availability_zones.available.names[0]}"
    Account           = "Subnet in Account: ${data.aws_caller_identity.current.account_id}"
    Region            = "Subnet in Region: ${data.aws_region.current.name}"
    RegionDescription = "Region Description: ${data.aws_region.current.name}"
  }
}

resource "aws_subnet" "vpc_subnet_2" {
  vpc_id              = aws_vpc.vpc_project.id
  availability_zone   = data.aws_availability_zones.available.names[1]
  cidr_block          = "192.168.2.0/24"
  tags = {
    Name              = "Subnet-2 ${data.aws_availability_zones.available.names[1]}"
    Account           = "Subnet in Account: ${data.aws_caller_identity.current.account_id}"
    Region            = "Subnet in Region: ${data.aws_region.current.name}"
    RegionDescription = "Region Description: ${data.aws_region.current.name}"
  }
}