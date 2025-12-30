# This is the single source of truth for defining Lambda-backed API endpoints.
# To add a new endpoint, copy one of the blocks below and change the values.
locals {
  endpoints = {
    # "fn" is the logical name for the endpoint
    "fn" = {
      handler_path = "lambdas/fn/index.handler"
      api_method   = "GET"
      api_path     = "/fn"
    },
    "fnId" = {
      handler_path = "lambdas/fnId/index.handler"
      api_method   = "GET"
      api_path     = "/fn/{id}"
    },
    "ddb" = {
      handler_path = "lambdas/ddb/index.handler"
      api_method   = "GET"
      api_path     = "/ddb/{id}"
    }
  }
}
