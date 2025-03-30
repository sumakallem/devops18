resource "aws_launch_template" "web_server_as" {
    name = "project_mono_3"
    image_id           = "ami-01bd9d8f06d29d6a0"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t2.nano"
    key_name = "devops"
    tags = {
        Name = "DevOps"
    }
    
}
   
  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb3"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-01f2c32ef6cb62ecd", "subnet-04ce12a377063caa3"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg3"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["ap-south-1b", "ap-south-1a"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

