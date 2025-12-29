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
    "fn1" = {
      handler_path = "lambdas/fn1/index.handler"
      api_method   = "GET"
      api_path     = "/fn1"
    },
    "fn2" = {
      handler_path = "lambdas/fn2/index.handler"
      api_method   = "GET"
      api_path     = "/fn2"
    },
    "fn3" = {
      handler_path = "lambdas/fn3/index.handler"
      api_method   = "GET"
      api_path     = "/fn3"
    },
    "fnId" = {
      handler_path = "lambdas/fnId/index.handler"
      api_method   = "GET"
      api_path     = "/fn/{id}"
    }
  }
}
