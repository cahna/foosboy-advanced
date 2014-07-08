
import config, default_config from require "lapis.config"

-- Helper to quickly extract local variable copies of ENV vars
ENV = setmetatable {}, __index: (k) => os.getenv k

import
  APP_SESSION_NAME
  APP_SECRET
  APP_PORT
  PGSQL_USER
  PGSQL_PASSWORD
  PGSQL_DATABASE
  PGSQL_HOST
  PWD
  TRAVIS_BUILD_ID
  TRAVIS_COMMIT
  HEROKU_POSTGRESQL_AMBER_URL
from ENV

-- This line is a band-aid fix for fig/docker dynamic port allocation when linking containers
if pg_port = os.getenv "DB_1_PORT_5432_TCP_PORT"
  PG_HOST ..= ":#{pg_port}"

-- Shared configurations
default_config.pwd             = PWD
default_config.port            = APP_PORT or 8080
default_config.num_workers     = 4
default_config.lua_code_cache  = "on"
default_config.daemon          = "off"

-- Configuration Environments
config {"development", "test"}, ->
  session_name   "development_session"
  secret         "development_secret"

  postgres ->
    user      "postgres"
    password  ""
    database  "foosboy_adv"
    host      "127.0.0.1"

config {"production", "fig", "drone", "ci"}, ->
  session_name   APP_SESSION_NAME
  secret         APP_SECRET

  postgres ->
    user      PGSQL_USER
    password  PGSQL_PASSWORD
    database  PGSQL_DATABASE
    host      PGSQL_HOST

config "travis", ->
  session_name    TRAVIS_BUILD_ID
  secret          TRAVIS_COMMIT
  lua_code_cache  "off"
  daemon          "on"

  postgres ->
    host      "localhost"
    user      "postgres"
    password  ""
    database  PGSQL_DATABASE

config "heroku", ->
  session_name   APP_SESSION_NAME
  secret         APP_SECRET
  postgres       HEROKU_POSTGRESQL_AMBER_URL

