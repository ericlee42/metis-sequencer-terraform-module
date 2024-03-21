output "themis-eip" {
  value = aws_eip.sequencers[0].public_ip
}

output "l2geth-eip" {
  value = aws_eip.sequencers[1].public_ip
}

output "eip-association-role-arn" {
  value = aws_iam_role.eip-association-role.arn
}
