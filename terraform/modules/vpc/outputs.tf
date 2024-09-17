output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_route_table_az1" {
  value = aws_route_table.private_route_table_az1
}

output "private_route_table_az2" {
  value = aws_route_table.private_route_table_az2
}

output "database_route_table" {
  value = aws_route_table.database_route_table
}

output "private_app_subnet_az1_id" {
  value = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  value = aws_subnet.private_app_subnet_az2.id
}

output "private_database_subnet_az1_id" {
  value = aws_subnet.private_database_subnet_az1.id
}

output "private_database_subnet_az2_id" {
  value = aws_subnet.private_database_subnet_az2.id
}

output "availability_zone_1" {
  value = data.aws_availability_zones.available_zones.names[0]
}

output "availability_zone_2" {
  value = data.aws_availability_zones.available_zones.names[1]
}
