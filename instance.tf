terraform {
  backend "s3" {
    bucket = "jblabs-yoav-007"
    key    = "s3yoav/myfinal"
    region = "us-east-1"
  }
}

resource "aws_key_pair" "nb-keypair" {
  key_name   = "ssh-key-pair"
  public_key = file("./ssh/builder-final-key.pub")
}

resource "aws_instance" "builder" {
  ami                    = var.AMIS[var.AWS_REGION]
  availability_zone      = "us-east-1a"
  instance_type          = "t3.small"
  subnet_id              = "subnet-0be92e05246bd1d97"
  vpc_security_group_ids = [aws_security_group.allow_inbound.id]
  key_name               = aws_key_pair.nb-keypair.key_name

  tags = {
    Name = "builder"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",

      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo systemctl is-active docker",
      "sudo apt-get install  -y docker-compose-v2",
      "docker compose version",
      "curl -fSL https://get.k3s.io -o /tmp/install-k3s.sh",
"sudo sh /tmp/install-k3s.sh",
"sudo systemctl is-active k3s",
"sudo k3s kubectl create namespace argocd",
"sudo k3s kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml",
"sudo k3s kubectl get pods -n argocd",




    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ssh/builder-final-key")
    host        = self.public_ip
  }
}
output "ssh_location" {
  value = "./ssh/builder-final-key"

}
output "ip" {
  value = aws_instance.builder.public_ip
}

output "security_group" {
  value = aws_security_group.allow_inbound.id
}