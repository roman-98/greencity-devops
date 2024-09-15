output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}

output "eip-for-nat-gateway-az1" {
  value = aws_eip.eip-for-nat-gateway-az1
}

output "eip-for-nat-gateway-az2" {
  value = aws_eip.eip-for-nat-gateway-az2
}

output "eip-for-nat-gateway-az3" {
  value = aws_eip.eip-for-nat-gateway-az3
}

output "nat-gateway-az1" {
  value = aws_nat_gateway.nat-gateway-az1
}

output "nat-gateway-az2" {
  value = aws_nat_gateway.nat-gateway-az2
}

output "nat-gateway-az3" {
  value = aws_nat_gateway.nat-gateway-az3
}

output "public_route_table" {
  value = aws_route_table.public_route_table
}

output "private_route_table_az1" {
  value = aws_route_table.private_route_table_az1
}

output "private_route_table_az2" {
  value = aws_route_table.private_route_table_az2
}

output "private_route_table_az3" {
  value = aws_route_table.private_route_table_az3
}

output "database_route_table" {
  value = aws_route_table.database_route_table
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "public_subnet_az3_id" {
  value = aws_subnet.public_subnet_az3.id
}

output "private_app_subnet_az1_id" {
  value = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  value = aws_subnet.private_app_subnet_az2.id
}

output "private_app_subnet_az3_id" {
  value = aws_subnet.private_app_subnet_az3.id
}

output "private_database_subnet_az1_id" {
  value = aws_subnet.private_database_subnet_az1.id
}

output "private_database_subnet_az2_id" {
  value = aws_subnet.private_database_subnet_az2.id
}

output "private_database_subnet_az3_id" {
  value = aws_subnet.private_database_subnet_az3.id
}

output "availability_zone_1" {
  value = data.aws_availability_zones.available_zones.names[0]
}

output "availability_zone_2" {
  value = data.aws_availability_zones.available_zones.names[1]
}

output "availability_zone_3" {
  value = data.aws_availability_zones.available_zones.names[2]
}