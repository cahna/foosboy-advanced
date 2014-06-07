
import prod, dev from require "secret.environment_vars"
import config, default_config from require "lapis.config"

default_config.pwd = os.getenv "PWD"

config {"development", "production"}, ->
  pg = prod.pgsql
  postgresql_url user: pg.user, password: pg.pass, database: pg.db

  num_workers 4
  code_cache "on"
  session_name "foosboy"
  secret prod.secret

