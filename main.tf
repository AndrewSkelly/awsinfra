# Configure AWS as Provider in Dublin Region
provider "aws" {
  region = "eu-west-1"
}

variable "key_name" {}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "TUDproj23"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_security_group" "ec2sec" {
  name_prefix = "ec2sec"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "api_server" {
  ami                         = "ami-0e1dc7c0757fa9cdc" # Amazon Linux 2 AMI ID
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2sec.id]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = tls_private_key.example.private_key_pem
    }
    inline = [
      "sudo mkdir -p ~/.ssh",
      "sudo echo '${aws_key_pair.generated_key.public_key}' >> ~/.ssh/authorized_keys",
      "sudo chmod 700 ~/.ssh",
      "sudo chmod 600 ~/.ssh/authorized_keys",
      "sudo yum update -y",
      "export RDS_ENDPOINT=${aws_db_instance.mysqldb.endpoint}",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      # "sudo a2enmod proxy",
      # "sudo a2enmod proxy_http",
      //Proxy for Car API
      "cd /etc/httpd/conf.d/",
      "sudo bash -c 'cat > /etc/httpd/conf.d/carapi.conf <<EOF",
      "<VirtualHost *:80>",
      "    ServerName ${self.public_ip}",
      "    ProxyPreserveHost On",
      "    ProxyRequests Off",
      "    ProxyPass / http://localhost:3001/",
      "    ProxyPassReverse / http://localhost:3001/",
      "</VirtualHost>",
      "EOF'",
      "sudo service httpd restart",
      "sudo yum install -y mysql",
      "sudo yum install -y git",
      "sudo chmod -R 777 /var/www",
      # "sudo echo '<html><body><h1>Hello, World! - Apache is up and running!</h1></body></html>' > /var/www/html/index.html",
      "sudo mysql -h ${aws_db_instance.mysqldb.endpoint} -u ${var.db_username} -p${var.db_password} -e 'CREATE DATABASE cars_db;'",
      "sudo mysql -h ${aws_db_instance.mysqldb.endpoint} -u ${var.db_username} -p${var.db_password} cars_db -e 'CREATE TABLE cars (id INT AUTO_INCREMENT PRIMARY KEY, brand VARCHAR(255), registration VARCHAR(255), points INT);'",
      "sudo mysql -h ${aws_db_instance.mysqldb.endpoint} -u ${var.db_username} -p${var.db_password} cars_db -e \"INSERT INTO cars (brand, registration, points) VALUES ('Toyota', '08-MO-2444', 100), ('Ford', '09-D-21435', 80), ('Honda', '131-C-52450', 120);\"",
      "sudo echo 'export INSTANCE_PUBLIC_IP=${aws_db_instance.mysqldb.endpoint}' > env.sh",
      "sudo git clone https://github.com/AndrewSkelly/carapi /home/ec2-user/carapi",
      "sudo cd /home/",
      "sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash",
      ". ~/.nvm/nvm.sh",
      "export NVM_DIR=\"$HOME/.nvm\"",
      // "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"",
      // "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"",
      "nvm install 16",
      "cd /home/ec2-user/carapi",
      "sudo chmod -R 777 /home/ec2-user/carapi/",
      "npm install",
      "node index.js",
      "exit",
    ]
  }
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "rds_endpoint" {
  value = aws_db_instance.mysqldb.endpoint
}


# Create a SQL Database
resource "aws_db_instance" "mysqldb" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  db_name                = "cars_db"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.ec2sec.id]
}
