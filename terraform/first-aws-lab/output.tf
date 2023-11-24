output "vpc_id" {
  value = aws_vpc.lab.id
}

output "build" {
  value = {
    ip  = aws_instance.demo.public_ip,
    dns = aws_instance.demo.public_dns
  }
}
