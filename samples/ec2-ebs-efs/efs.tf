# Creating Amazon EFS File system
# Amazon EFS supports two lifecycle policies. Transition into IA and Transition out of IA
resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "efs-example"
  }
}

# Creating the EFS access point for AWS EFS File system
resource "aws_efs_access_point" "access_point" {
  file_system_id = aws_efs_file_system.efs.id
}

# Creating the AWS EFS System policy to transition files into and out of the file system.
# The EFS System Policy allows clients to mount, read and perform, write operations on File system 
# The communication of client and EFS is set using aws:secureTransport Option
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

# Creating the AWS EFS Mount point in a specified Subnet 
resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public.id
  security_groups = [aws_security_group.sg_config.id]  # open ingress 2049 port for EFS
}

resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
   
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("testkey.pem")
    host     = aws_instance.ubuntu2004.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install nfs-common -y",
      "mkdir ~/efs",
      "cd ~/efs",
      "df -kh"
    ]
  }
}