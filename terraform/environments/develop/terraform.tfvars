env_config = {
  aws_region   = "eu-west-1"
  project_name = "test-tf-microservice"
  env_name     = "develop"
}

vpc_config = {
  subnet_ids         = ["subnet-013eff5b", "subnet-fb189f9d", "subnet-0834a340"]
  security_group_ids = ["sg-a5e2f0d8"]
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
  timeout_seconds    = 15
}
