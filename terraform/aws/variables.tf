variable "hyperion_nb_nodes" {
  description = "The number of nodes."
  default = "2"
}

variable "aws_access_key" {
  description = "AWS access key."
}

variable "aws_secret_key" {
    description = "AWS secret key."
}

variable "aws_region" {
    description = "AWS region."
    default = "eu-west-1"
}

variable "aws_key_name" {
    description = "The SSH key name to use for the instances."
}

variable "aws_ssh_public_key" {
  description = "Path to the SSH public key."
}

variable "aws_ssh_private_key_file" {
    description = "Path to the SSH private key file."
}

variable "aws_ssh_user" {
    description = "SSH user."
    default = "ubuntu"
}

variable "aws_vpc_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
    default = "10.0.0.0/16"
}

variable "aws_subnet_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
    default = "10.0.1.0/24"
}

variable "aws_image" {
    description = "The name of the image to base the launched instances."
}

variable "aws_instance_type_master" {
    description = "The machine type to use for the Hyperion master instance."
    default = "m3.medium"
}

variable "aws_instance_type_node" {
    description = "The machine type to use for the Hyperion nodes instances."
    default = "m3.medium"
}
