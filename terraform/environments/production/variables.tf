variable "env_config" {
  description = "Environment configuration"
  type = object({
    aws_region   = string
    project_name = string
    env_name     = string
  })
}

variable "dynamodb_config" {
  description = "DynamoDB config"
  type = object({
    table_name = optional(string, "Environments")
  })
}

variable "sql_server_config" {
  description = "SQL Server config"
  type = object({
    db_host     = string
    db_user     = optional(string, "sa")
    db_password = optional(string, "Password1234")
    db_name     = optional(string, "db")
  })
}

variable "lambda_config" {
  description = "Lambda config"
  type = object({
    # memory_size_mb     = optional(number, 128)
    log_retention_days = optional(number, 30)
  })
}
