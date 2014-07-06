
import config, default_config from require "lapis.config"

-- Helper to quickly extract local variable copies of ENV vars
ENV = setmetatable {}, __index: (k) => os.getenv k

import
  APP_SESSION_NAME
  APP_SECRET
  APP_PORT
  PG_USERNAME
  PG_PASSWORD
  PG_DBNAME
  PG_HOST
  PWD
  TRAVIS_BUILD_ID
  TRAVIS_COMMIT
from ENV

if pg_port = os.getenv "DB_1_PORT_5432_TCP_PORT"
  PG_HOST ..= ":#{pg_port}"

-- Shared configurations
default_config.pwd             = PWD
default_config.port            = APP_PORT or 8080
default_config.num_workers     = 4
default_config.lua_code_cache  = "on"
default_config.daemon          = "of"

-- Configuration Environments
config {"production", "test", "development"}, ->
  session_name   APP_SESSION_NAME
  secret         APP_SECRET

  postgres ->
    host      PG_HOST
    user      PG_USERNAME
    password  PG_PASSWORD
    database  PG_DBNAME

config "travis", ->
  session_name  "Travis#{TRAVIS_BUILD_ID}"
  secret        "Travis#{TRAVIS_COMMIT}"

  postgres ->
    host      "localhost"
    user      "postgres"
    password  ""
    database  "travis_ci_test"
