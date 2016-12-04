provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  # The same availability zone as our instances
  availability_zones = ["${aws_instance.web.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # The instances are registered automatically
  instances = ["${aws_instance.web.*.id}"]
}

resource "aws_instance" "web" {
instance_type = "m1.small"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"

  # This will create 4 instances
  count = "${var.count}"
  key_name = "${aws_key_pair.deployer.key_name}"


#connection {
#    type = "ssh"
#    user = "ubuntu"
#    key_file = "~/.ssh/id_rsa"    
#    agent = true
# }
key_name = "${aws_key_pair.deployer.key_name}"
provisioner "local-exec" {
      command = "echo ${aws_instance.web.public_ip} >> public_ips.txt" 
      #command = "ansible-playbook infra.yml"
     }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.6"
  instance_class       = "db.t1.micro"
  name                 = "mydb"
  username             = "root"
  password             = "12345678"
  parameter_group_name = "default.mysql5.6"
}
