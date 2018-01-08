# ECS Container Instances

resource "aws_instance" "ecs-instance01" {
    ami                         = "${lookup(var.amis, var.region)}"
    instance_type               = "${var.instance_type}"
    availability_zone           = "us-west-2a"
    subnet_id                   = "${aws_subnet.wp-public-tf.id}"
    key_name                    = "${var.key_name}"
    associate_public_ip_address = true
    iam_instance_profile        = "ecsInstanceRole"
    security_groups             = ["${aws_security_group.wp-ecs-sg-tf.id}"]
    user_data                   = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.default.name} > /etc/ecs/ecs.config"
    tags {
      Name = "ecs-instance01"
    }
}

resource "aws_instance" "ecs-instance02" {
    ami                         = "${lookup(var.amis, var.region)}"
    instance_type               = "${var.instance_type}"
    availability_zone           = "us-west-2a"
    subnet_id                   = "${aws_subnet.wp-public-tf.id}"
    key_name                    = "${var.key_name}"
    associate_public_ip_address = true
    iam_instance_profile        = "ecsInstanceRole"
    security_groups             = ["${aws_security_group.wp-ecs-sg-tf.id}"]
    user_data                   = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.default.name} > /etc/ecs/ecs.config"
    tags {
      Name = "ecs-instance02"
    }
}
