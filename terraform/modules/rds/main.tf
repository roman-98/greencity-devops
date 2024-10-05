resource "aws_db_instance" "greencity" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  username                = var.username
  password                = var.password
  db_name                 = var.db_name
  skip_final_snapshot     = var.skip_final_snapshot
  multi_az                = var.multi_az

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "greencity_secrets_v1" {
  secret_id     = "prod/greencity-secrets-v1"

  secret_string = jsonencode({
    DATASOURCE_URL = format("jdbc:postgresql://%s/greencity", aws_db_instance.greencity.endpoint)
  })

  depends_on = [aws_db_instance.greencity]
}

