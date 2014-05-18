
import prod, dev from require "secret.environment_vars"
import config, default_config from require "lapis.config"

default_config.pwd = os.getenv "PWD"

config "production", ->
  pg = dev.pgsql -- TODO: Create a prod db and change this

  num_workers 4
  code_cache "on"
  session_name "foosboy"
  postgresql_url "postgres://#{pg.user}:#{pg.pass}@#{pg.host or '127.0.0.1'}/#{pg.db}"
  secret prod.secret

config {"development", "test"}, ->
  pg = dev.pgsql

  num_workers 1
  code_cache "off"
  session_name "foosboy_dev"
  postgresql_url "postgres://#{pg.user}:#{pg.pass}@#{pg.host or '127.0.0.1'}/#{pg.db}"
  secret dev.secret

  luminary ->
    enable_console false

