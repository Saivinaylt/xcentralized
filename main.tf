resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = var.vpc_tags

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.igtags
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = merge(
    var.public_subnet_tags,
    {
      Name = "${var.project_name}-public-${local.last_element[count.index]}"  
    }
)
}

resource "aws_route_table" "public_route" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = var.public_route_table_tags

}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public_route.id


}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = merge(
    var.private_subnet_tags,
    {
      Name = "${var.project_name}-private-${local.last_element[count.index]}"  
    }
)
}

resource "aws_route_table" "private_route" {

  vpc_id = aws_vpc.main.id

  tags = var.privat_route_table_tags
}




resource "aws_route_table_association" "private" {
   count = length(var.private_subnet_cidr) 
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private_route.id
}

# [project-name]-database-1a/1b
resource "aws_subnet" "database" {
  #count = length(var.database_subnet_cidr) #count=2
  count = length(var.database_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(
    var.database_subnet_tags,
    {
        Name = "${var.project_name}-database-${local.azs_labels[count.index]}"
    }
  )
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id
        cidr_block = "0.0.0.0/0"
     tags = merge(
        var.database_route_table_tags,
        {
            Name = "${var.project_name}-database"
        }
    )
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr) # this will fetch the length of private subnets
  subnet_id      = element(aws_subnet.database[*].id, count.index) # this will iterate and each time it gives single element
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = merge(
    var.nat_gate_tags,
    {
        Name="${var.project_name}-eip"
    }
  )
}



resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.gw_tags,
    {
        Name= "${var.project_name}-gw"
    }
  )
}

