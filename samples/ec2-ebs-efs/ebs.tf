# Creating EBS for Ubuntu
# details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "ebs_ubuntu" {
  availability_zone = "eu-central-1c"
  size = 20   # The size of the drive in GiBs.
  type= "gp2" # default gp2. others: standard, gp2, gp3, io1, io2, sc1 or st1
}

# EBS-Ubuntu attachment
resource "aws_volume_attachment" "ubuntu2004_ebs_ubuntu" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs_ubuntu.id}"
  instance_id = "${aws_instance.ubuntu2004.id}"
}

# Creating EBS for Windows
# details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "ebs_windows" {
  availability_zone = "eu-central-1c"
  size = 15   # The size of the drive in GiBs.
  type= "gp2" # default gp2. others: standard, gp2, gp3, io1, io2, sc1 or st1
}

# EBS-Windows attachment
resource "aws_volume_attachment" "win2019_ebs_windows" {
  device_name = "/dev/sdg"
  volume_id   = "${aws_ebs_volume.ebs_windows.id}"
  instance_id = "${aws_instance.win2019.id}"
}