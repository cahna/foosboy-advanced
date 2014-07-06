
import config, default_config from require "lapis.config"
import getenv from os

{
  :APP_SESSION_NAME
  :APP_SECRET
  :APP_PORT
  :PG_USERNAME
  :PG_PASSWORD
  :PG_DBNAME
  :PG_HOST
  :PWD
} = setmetatable {}, __index: (k) => os.getenv k

if pg_port = getenv "DB_1_PORT_5432_TCP_PORT"
  PG_HOST ..= ":#{pg_port}"

-- Shared configurations
default_config.pwd         = PWD
default_config.port        = APP_PORT or 8080
default_config.num_workers = 4

-- Configuration Environments
config {"production", "test", "development"}, ->
  num_workers    8
  lua_code_cache "on"
  daemon         "off"
  session_name   APP_SESSION_NAME
  secret         APP_SECRET

  postgres ->
    host      PG_HOST
    user      PG_USERNAME
    password  PG_PASSWORD
    database  PG_DBNAME

