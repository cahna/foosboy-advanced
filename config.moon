
import prod, dev from require "secret.environment_vars"
import config, default_config from require "lapis.config"

pg = prod.pgsql

-- Shared configurations
default_config.pwd = os.getenv "PWD"
default_config.port = 8080
default_config.num_workers = 4

config "development", ->
  num_workers 8
  code_cache "off"
  daemon "off"
  secret "secret_test_key_is_secret"
  postgresql_url user: pg.user, password: pg.pass, database: pg.db

config "test", ->
  code_cache "on"
  daemon "on"
  secret "secret_test_key_is_secret"
  postgresql_url user: pg.user, password: pg.pass, database: pg.db

config "production", ->
  port 80
  num_workers 8
  code_cache "on"
  daemon "off"
  secret "thisshouldreallybemoresecret"
  postgresql_url user: pg.user, password: pg.pass, database: pg.db

