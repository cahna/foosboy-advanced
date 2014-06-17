
import getenv from os

-- A helper for heroku environment-to-dsl translation
env_pgurl = getenv "HEROKU_POSTGRESQL_AMBER_URL"

if env_pgurl and env_pgurl\len! > 3
  import setenv from require "posix"
  -- 'postgres://user:password@database.domain.com/databasename'
  env_pgurl\gsub "postgres://(%w%d):(%w%d)@(.+)/([a-zA-Z0-9%-%_]+)$", (user, pass, host, dbname) ->
    print user, pass, host, dbname
    setenv "PGSQL_USER", user
    setenv "PGSQL_PASSWORD", pass
    -- TODO: May need this to parse out port # from this string (potentially)
    setenv "PGSQL_HOST", host
    setenv "PGSQL_DATABASE", dbname

{
  prod: {
    port: getenv("APP_PORT")
    secret: getenv("APP_SECRET")
    pgsql: {
      user: getenv("PGSQL_USER")
      pass: getenv("PGSQL_PASSWORD")
      db: getenv("PGSQL_DATABASE")
      host: getenv("PGSQL_HOST") or "127.0.0.1"
      port: getenv("PGSQL_PORT") or 5432
    }
  }
}

