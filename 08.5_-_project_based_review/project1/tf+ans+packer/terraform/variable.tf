## Intended to come from terraform cloud variable set
variable "aws_secret_access_key" {
  type = string
  sensitive = true
}

variable "aws_access_key_id" {
  type = string
  sensitive = true
}
