# command
# packer validate -var-file=example.pkrvars.hcl example.pkr.hcl
# packer build -var-file=example.pkrvars.hcl example.pkr.hcl

# source
source "amazon-ebs" "ec2_ami" {
    region              = var.region
    ami_name            = "${var.env}-AMI-${var.version}"
    instance_type       = var.instance_type
    source_ami          = var.source_ami

    # Network Configuration
    vpc_id              = var.vpc_id
    subnet_id           = var.subnet_id
    ssh_username        = var.ssh_username
    communicator        = "ssh"
    ssh_timeout         = "10m"
    ssh_interface       = "public_ip"
}

# build
build {
    # Get EC2 Image
    sources = [
        "source.amazon-ebs.ec2_ami"
    ]
    
    provisioner "ansible" {
        playbook_file   = "ansible/playbook.yml"
    }
}

# variable
variable "ssh_username" {
    default = "ubuntu" # ubuntu default
}
variable "instance_type" {
    default = "t2.micro" # AWS freetier
}
variable "vpc_id" {
    default = "vpc-05d7f0d034b2b6acc" # default vpc
}
variable "subnet_id" {
    default = "subnet-046821c93066ea56a" # default vpc - default subnet
}
variable "source_ami" {
    default = "ami-04876f29fd3a5e8ba" # ubuntu 20.04 AMI
}
variable "region" {
    default = "ap-northeast-2" # Seoul region
}
variable "env" {
    default = "test" # service environment
}
variable "version" {
    default = "v0.0" # service version
}