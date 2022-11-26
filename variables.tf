#DB name 사전 입력
variable "db_name" {
  type        = string
  default     = "boseungrdstestdb"
}

#DB username, password 설정
variable "boseung_rds_cred" {
  default = {
    username = "admin"
    password = "Password1!!!!"
  }
  type = map(string)
}
