
# Wordpress on ECS

Practical example on how to get a Wordpress running under an Amazon ECS Cluster using different technologies.

## Technologies

* [Wordpress](https://wordpress.org/)
* [Packer](https://www.packer.io/)
* [Docker](https://www.docker.com/)
* [Ansible](https://www.ansible.com/)
* [Terraform](https://www.terraform.io/)
* [Amazon ECS](https://aws.amazon.com/ecs/)
* [Amazon RDS](https://aws.amazon.com/es/rds/)

## Requirements

To use this example you will need an [AWS](https://aws.amazon.com/es/) account and:

* [Packer](https://www.packer.io/downloads.html)
* [Terraform](https://www.terraform.io/downloads.html)
* [Docker](https://docs.docker.com/engine/installation/)

## Usage

1. Build the Wordpress container.

Packer will use a [base Docker image with Ansible](https://github.com/jfusterm/dockerfiles/blob/master/ansible/Dockerfile) to provision all the applications needed to run a Wordpress. The result will be saved into a container named `jfusterm/wp-packer` with a version tag `4.4.2`.

**Note**: If you want to change the image tag you have to change it in `wp-packer.json` and `wordpress.json`.

```
# packer build wp-packer.json
```

2. Push the container to [Dockerhub](https://hub.docker.com/)

Check that the image is ready.

```
# docker images

REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
jfusterm/wp-packer        4.4.2               60bfb4ef7e9d        3 hours ago         138.2 MB
```

Then you can push it to Dockerhub.

```
# docker login
# docker push jfusterm/wp-packer:4.4.2
```

3. Deploy all the infrastructure needed on AWS using Terraform.

```
# terraform apply
```

Once deployed, Terraform will display the ECS Container Instances public IPs and the [ELB](https://aws.amazon.com/es/elasticloadbalancing/) URL that will distribute the traffic across the different Wordpress container instances.

The RDS connection parameters will be passed on runtime to the Wordpress containers via environment variables.

4. Once not needed, we can remove all the AWS infrastructure:


```
# terraform destroy
```

## Considerations

This example uses a basic and simple approach to get a ready to use Wordpress using different technology. Further modifications will be done to get a fully automated, scalable and high available Wordpress. Some thoughts:

* Wrap all the steps in a single script: build the container, push the container to Dockerhub or a private registry and finally deploy all the infrastructure on AWS.
* ~~Automate Wordpress installation when the first instance is launched. **Note**: Currently the ELB won't work properly due to the health-checks configuration until Wordpress is installed from one of the Worpress instances.~~
* Distribute the ECS Container Instances across different availability zones and route the traffic using the ELB among them.
* Decouple Nginx and PHP-FPM in separate containers so can be scaled independently.
* Use a shared or distributed storage system to persist Wordpress' data. Examples:
    * [Amazon EFS](https://aws.amazon.com/efs/)
    * [GlusterFS](https://www.gluster.org/)
    * [Flocker](https://docs.clusterhq.com/en/latest/docker-integration/)
* Remove the RDS single point of failure. Examples:
    * Deploy RDS on [Multi-AZ](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)
    * Use [Percona XtraDB Cluster](https://www.percona.com/software/mysql-database/percona-xtradb-cluster)
