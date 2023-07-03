output "vpc-id" {
    value = aws_vpc.main.id
}

output "Public_subnet_id" {
    value = aws_subnet.public[*].id
  
}

output "private_subnet_id" {
    value = aws_subnet.private[*].id
  
}