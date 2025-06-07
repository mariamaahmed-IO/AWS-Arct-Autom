## Create AMI from one App Server

resource "aws_ami_from_instance" "utc_ami" {
  name               = "utcappserver"
  source_instance_id = aws_instance.app_server[0].id
  depends_on         = [aws_instance.app_server]
}
