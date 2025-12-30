env_config = {
  aws_region   = "eu-west-1"
  project_name = "test-tf-microservice"
  env_name     = "staging"
}

dynamodb_config = {
  table_name = "Environments"
}

sql_server_config = {
  db_host     = "localhost"
  db_user     = "sa"
  db_password = "Password1234"
  db_name     = "db"
}

lambda_config = {
  log_retention_days = 30
}
