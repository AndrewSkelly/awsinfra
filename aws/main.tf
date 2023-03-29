### Configure AWS as Provider in Dublin Region ###
provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "./modules/VPC"


}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "ITMProject Internet Gateway"
  }
}

resource "aws_route_table" "igwroute" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

module "public_subnet" {
  source = "./modules/PublicSubnet"

  vpc_id = module.vpc.vpc_id
}

module "private_subnet" {
  source = "./modules/PrivateSubnet"

  vpc_id = module.vpc.vpc_id
}

module "private_subnet_b" {
  source = "./modules/PrivateSubnetB"

  vpc_id = module.vpc.vpc_id
}

### Private Key Generation Imported from Keypair module directory ###
module "privkey" {
  source = "./modules/PrivateKey"
}

### Public Key Generation to create pair Imported from Keypair module directory ###
module "generated_key" {
  source     = "./modules/Keypair"
  public_key = module.privkey.public_key
}

# resource "aws_key_pair" "my_key_pair" {
#   key_name = "my-key-pair"
#   public_key = module.privkey.public_key_openssh
# }

### Security Group for EC2 & RDS Imported from SecurityGroups module directory ###
module "ec2sec" {
  source = "./modules/SecurityGroups"
  vpc_id = module.vpc.vpc_id
}

### MySql RDS Configuration Imported from RDS module directory ###
module "mysqldb" {
  source = "./modules/RDS"

  # Security Group imported for SecurityGroups module
  security_group_id   = module.ec2sec.security_group_id
  private_subnet_id   = module.private_subnet.private_subnet_id
  private_subnet_b_id = module.private_subnet_b.private_subnet_b_id
}

### VM Configuration Autoscale Group Imported from LaunchConfig module directory ###
module "cars-api-launch-config" {
  source = "./modules/LaunchConfig"

  # Security Group imported for SecurityGroups module
  security_group_id = module.ec2sec.security_group_id
  key_name          = module.generated_key.key_name
}

### VM Autoscale Group Configuration Imported from APIAutoScalingGroup module directory ###
module "carApiAutoscale" {
  source = "./modules/APIAutoScalingGroup"

  # Security Group imported for SecurityGroups module
  LaunchConfigName = module.cars-api-launch-config.LaunchConfigName
  public_subnet_id = module.public_subnet.public_subnet_id
}

# Configuration management instance
resource "aws_instance" "ansible_configuration" {
  ami                         = "ami-0e1dc7c0757fa9cdc" # Amazon Linux 2 AMI ID
  instance_type               = "t2.micro"
  key_name                    = module.generated_key.key_name
  subnet_id                   = module.public_subnet.public_subnet_id
  associate_public_ip_address = true
  # vpc_security_group_ids      = [module.ec2sec.security_group_id]
  security_groups = [module.ec2sec.security_group_id]
  # aws_security_group.ec2sec.id
  tags = {
    "name" = "Ansible-Host"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = module.privkey.private_key
  }

  provisioner "file" {
    source      = "car-api-configuration.yml"
    destination = "/home/ec2-user/car-api-configuration.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ~/.ssh",
      "sudo echo '${module.generated_key.public_key}' >> ~/.ssh/authorized_keys",
      "sudo chmod 700 ~/.ssh",
      "sudo chmod 600 ~/.ssh/authorized_keys",
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "echo '[carApiAutoscale]' | sudo tee -a /etc/ansible/hosts",
      # "echo '${module.carApiAutoscale.autoScalingGroupId}' | sudo tee -a /etc/ansible/hosts",
      "${join("", [for instance in module.carApiAutoscale.instances : "echo '${instance.private_ip}' | sudo tee -a /etc/ansible/hosts\n"])}"
      #     "ansible-playbook -i /etc/ansible/hosts ~/car-api-configuration.yml"
      # "export RDS_ENDPOINT=${aws_db_instance.mysqldb.endpoint}",
      # "sudo yum install -y httpd",
      # "sudo systemctl start httpd",
      # "sudo systemctl enable httpd",
      # "sudo a2enmod proxy",
      # "sudo a2enmod proxy_http",
      //Proxy for Car API
      # "cd /etc/httpd/conf.d/",
      # "sudo bash -c 'cat > /etc/httpd/conf.d/carapi.conf <<EOF",
      # "<VirtualHost *:80>",
      # "    ServerName ${self.public_ip}",
      # "    ProxyPreserveHost On",
      # "    ProxyRequests Off",
      # "    ProxyPass / http://localhost:3001/",
      # "    ProxyPassReverse / http://localhost:3001/",
      # "</VirtualHost>",
      # "EOF'",
      # "sudo service httpd restart",
      # "sudo yum install -y mysql",
      # "sudo yum install -y git",
      # "sudo chmod -R 777 /var/www",
      # "sudo echo '<html><body><h1>Hello, World! - Apache is up and running!</h1></body></html>' > /var/www/html/index.html",
      # "sudo mysql -h ${aws_db_instance.mysqldb.endpoint} -u ${var.db_username} -p${var.db_password} -e 'CREATE DATABASE cars_db;'",
      # "sudo mysql -h ${aws_db_instance.mysqldb.endpoint} -u ${var.db_username} -p${var.db_password} cars_db -e 'CREATE TABLE cars (id INT AUTO_INCREMENT PRIMARY KEY, brand VARCHAR(255), registration VARCHAR(255), points INT);'",
      # "sudo mysql -h ${aws_db_instance.mysqldb.endpoint} -u ${var.db_username} -p${var.db_password} cars_db -e \"INSERT INTO cars (brand, registration, points) VALUES ('Toyota', '08-MO-2444', 100), ('Ford', '09-D-21435', 80), ('Honda', '131-C-52450', 120);\"",
      # "sudo echo 'export INSTANCE_PUBLIC_IP=${aws_db_instance.mysqldb.endpoint}' > env.sh",
      # "sudo git clone https://github.com/AndrewSkelly/carapi /home/ec2-user/carapi",
      # "sudo cd /home/",
      # "sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash",
      # ". ~/.nvm/nvm.sh",
      # "export NVM_DIR=\"$HOME/.nvm\"",
      // "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"",
      // "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"",
      # "nvm install 16",
      # "cd /home/ec2-user/carapi",
      # "sudo chmod -R 777 /home/ec2-user/carapi/",
      # "npm install",
      # "node index.js",
      # "exit",
    ]
  }
}

# # Create Static IP
# resource "aws_eip" "staticip" {
#   vpc = true
# }


# Create a Target Group for the Auto Scaling Group instances
# resource "aws_lb_target_group" "carApiTargetGroup" {
#   name     = "carApiTargetGroup"
#   port     = 80
#   protocol = "HTTP"
#   health_check {
#     path = "/"
#   }
# }

# # Create a Load Balancer
# resource "aws_lb" "carApiLoadBalancer" {
#   name               = "carApiLoadBalancer"
#   internal           = false
#   load_balancer_type = "application"
# }

# # Attach the Target Group to the Load Balancer
# resource "aws_lb_listener" "carApiLoadBalancerListener" {
#   load_balancer_arn = aws_lb.carApiLoadBalancer.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.carApiTargetGroup.arn
#   }
# }



# # Associate the Elastic IP address with the Auto Scaling Group's instances
# resource "aws_eip_association" "staticipgroup" {
#   instance_id   = "${aws_launch_configuration.my-launch-config.id}"
#   allocation_id = "${aws_eip.staticip.id}"
# }







