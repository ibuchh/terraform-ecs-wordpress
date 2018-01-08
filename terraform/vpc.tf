# VPC

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr_block}"

    tags {
       Name = "wp-pvc-tf"
    }
}

# Internet Gateway

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"

    tags {
       Name = "wp-igw-tf"
    }
}

# Subnets

resource "aws_subnet" "wp-public-tf" {
    vpc_id            = "${aws_vpc.default.id}"
    cidr_block        = "${var.public_subnet_cidr_block}"
    availability_zone = "us-west-2a"

    tags {
       Name = "wp-public-tf"
    }
}

resource "aws_subnet" "wp-private-tf" {
    vpc_id            = "${aws_vpc.default.id}"
    cidr_block        = "${var.private_subnet_cidr_block}"
    availability_zone = "us-west-2b"

    tags {
       Name = "wp-private-tf"
    }
}

# Route Tables

resource "aws_route_table" "wp-rt-public-tf" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
       Name = "wp-rt-public-tf"
    }
}

resource "aws_route_table_association" "wp-public-tf" {
    subnet_id = "${aws_subnet.wp-public-tf.id}"
    route_table_id = "${aws_route_table.wp-rt-public-tf.id}"
}