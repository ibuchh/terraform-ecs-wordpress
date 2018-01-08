resource "aws_ecs_cluster" "default" {
    name = "${var.ecs_cluster_name}"
}

resource "aws_ecs_task_definition" "wordpress" {
    family = "wp-ecs-task-tf"
    container_definitions = "${template_file.wp-container.rendered}"
}

resource "aws_ecs_service" "wp-ecs-svc" {
    name = "wp-ecs-svc-tf"
    cluster = "${aws_ecs_cluster.default.id}"
    task_definition = "${aws_ecs_task_definition.wordpress.arn}"
    desired_count = 2

    iam_role = "ecsServiceRole"

    load_balancer {
        elb_name = "${aws_elb.default.id}"
        container_name = "wordpress"
        container_port = 80
    }
}