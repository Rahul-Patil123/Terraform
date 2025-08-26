resource "aws_default_security_group" "default-sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    engress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name: "${var.env_prefix}-default-sg"
    }
}
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amazon"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}
resource "aws_key_pair" "ssh-key" {
    key_name = "server-key-pair"
    public_key = file(var.my_public_key_location)
}

resource "aws_instance" "myapp-server" {
    # ami = "ami-0b83c7f5e2823d1f4"
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    # subnet_id = aws_subnet.myapp_subnet_1.id
    # subnet_id = module.myapp-subnet.subnet.id
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]

    associate_public_ip_address = true
    key_name = "server-key-pair"
    # This is a way to enter into EC2 instance using inline bash script
    # user_data = <<EOF
    #                 #!/bin/bash
    #                 sudo yum update -y && sudo yum install -y docker
    #                 sudo systemctl start docker
    #                 sudo usermod -aG docker ec2-user
    #                 docker run -p 8080:80 nginx
    #             EOF
    user_data = file("entry-script.sh")

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file(var.private_key_location)
    }
    privisioner "file" {
        source = "entry-script.sh"
        destination = "/home/ec2-user/entry-script.sh"
    }
    privisioner "remote-exec"{
        # inline = [
        #     "export ENV=dev",
        #     "mkdir newDir"
        # ]
        script = file("entry-script.sh")
    }
    privisioner "local-exec" {
        command = "echo {self.public_ip}"
    }
    tags = {
        Name: "${var.env_prefix}-server"
    }
}