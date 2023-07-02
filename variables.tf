variable "project_name" {
    type = string
  
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "igtags" {
      type = map
      default = {} 
  
}

variable "public_subnet_tags" {
  
  type = map
  default = {}
}

variable "public_subnet_cidr" {
    type = list
    validation {
    condition = (
      length(var.public_subnet_cidr) == 2 
      )
      error_message = "cidr must be 2 cidr"
  }
  
}

variable "private_subnet_tags" {
  
  type = map
  default = {}
}

variable "private_subnet_cidr" {
    type = list
     validation {
    condition = (
      length(var.private_subnet_cidr) == 2 
      )
      error_message = "cidr must be 2 cidr"
  }
  
}

variable "nat_gate_tags" {
    type = map
    default = {}
}

variable "gw_tags" {
    type = map
    default = {}

  
}

variable "public_route_table_tags" {
    type = map
    default = {}
   
  
}

variable "privat_route_table_tags" {

     type = map
    default = {}
   
  
}