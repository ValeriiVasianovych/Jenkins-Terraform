output "vpc_region" {
  value = data.aws_region.current.name
}

output "vpc_region_description" {
  value = data.aws_region.current.description
}

output "vpc_id" {
  value = aws_vpc.vpc_project.id
}

output "vpc_subnet_1_id" {
  value = aws_subnet.vpc_subnet_1.id
}

output "vpc_subnet_2_id" {
  value = aws_subnet.vpc_subnet_2.id
}

output "vpc_subnet_1_az" {
  value = aws_subnet.vpc_subnet_1.availability_zone
}

output "vpc_subnet_2_az" {
  value = aws_subnet.vpc_subnet_2.availability_zone
}