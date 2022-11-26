
#SecretManager 통해 ID/PW 암호화 진행
resource "aws_secretsmanager_secret" "boseung_rds_cred" {
  name = "boseung_rds_cred5"
}

resource "aws_secretsmanager_secret_version" "boseung_rds_cred" {
  secret_id     = aws_secretsmanager_secret.boseung_rds_cred.id
  secret_string = jsonencode(var.boseung_rds_cred)
}

#암호화 한 username, PW 불러오기
data "aws_secretsmanager_secret" "boseung_rds_cred_secret" {
  name = "boseung_rds_cred5"
  depends_on = [
    aws_secretsmanager_secret.boseung_rds_cred
  ]
}

data "aws_secretsmanager_secret_version" "encrypt_secret" {
  secret_id = data.aws_secretsmanager_secret.boseung_rds_cred_secret.id
  depends_on = [
    aws_secretsmanager_secret_version.boseung_rds_cred
  ]
}

#DB명, username, PW 값으로 rds 생성
resource "aws_db_instance" "boseung_rds" {
  identifier        = "boseungdb"
  db_name           = var.db_name
  allocated_storage = 16
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.medium"

  username = jsondecode(data.aws_secretsmanager_secret_version.encrypt_secret.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.encrypt_secret.secret_string)["password"]
}