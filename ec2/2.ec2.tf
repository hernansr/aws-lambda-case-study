resource "aws_instance" "alarm_test" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "dummy"
}