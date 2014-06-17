
import getenv from os

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

