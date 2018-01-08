resource "aws_elb" "default" {
    name               = "wp-elb-tf"
    subnets            = ["${aws_subnet.wp-public-tf.id}"]
    security_groups    = ["${aws_security_group.wp-elb-tf.id}"]

    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        target              = "HTTP:80/"
        interval            = 30
    }

    tags {
        Name = "wp-elb-tf"
    }
}

resource "aws_lb_cookie_stickiness_policy" "wp-elb-tf-policy" {
    name                     = "wp-elb-tf-policy"
    load_balancer            = "${aws_elb.default.id}"
    lb_port                  = 80
    cookie_expiration_period = 600
}