resource "aws_key_pair" "deployer" {
  key_name = "${var.aws_key_name}"
  public_key = "${file("${var.aws_ssh_public_key}")}"
}

resource "aws_vpc" "hyperion-network" {
  cidr_block = "${var.aws_vpc_cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "hyperion"
  }
}

resource "aws_subnet" "hyperion-network" {
  vpc_id = "${aws_vpc.hyperion-network.id}"
  cidr_block = "${var.aws_subnet_cidr_block}"
  map_public_ip_on_launch = true
  tags {
    Name = "hyperion"
  }
}

resource "aws_internet_gateway" "hyperion-network" {
  vpc_id = "${aws_vpc.hyperion-network.id}"
}

resource "aws_route_table" "hyperion-network" {
  vpc_id = "${aws_vpc.hyperion-network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hyperion-network.id}"
  }
}

resource "aws_route_table_association" "hyperion-network" {
  subnet_id = "${aws_subnet.hyperion-network.id}"
  route_table_id = "${aws_route_table.hyperion-network.id}"
}

resource "aws_security_group" "hyperion-network" {
  name = "hyperion"
  description = "Hyperion security group"
  vpc_id = "${aws_vpc.hyperion-network.id}"
  ingress {
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "hyperion"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.hyperion-master.id}"
  vpc = true
  connection {
    # host = "${aws_eip.ip.public_ip}"
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }
}

resource "aws_instance" "hyperion-master" {
  ami = "${var.aws_image}"
  instance_type = "${var.aws_instance_type_master}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.hyperion-network.id}"
  security_groups = [
    "${aws_security_group.hyperion-network.id}",
  ]
  tags {
    Name = "hyperion-master"
  }

  connection {
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get install -y python2.7"
    ]
  }

}

resource "aws_instance" "hyperion-nodes" {
  depends_on = ["aws_eip.ip"]
  count = "${var.hyperion_nb_nodes}"
  ami = "${var.aws_image}"
  instance_type = "${var.aws_instance_type_node}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.hyperion-network.id}"
  security_groups = [
    "${aws_security_group.hyperion-network.id}",
  ]
  tags {
    Name = "hyperion-node-${count.index}"
  }

  connection {
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get install -y python2.7"
    ]
  }

}
