
-- This is an example of how the environment-specific secret configuration
-- variables are read from conf.moon

{
  prod: {
    secret: "soop3r$ecre7RandoMstr1ng!"
    pgsql: {
      user: "a_postgres_user"
      pass: "the_password"
      db: "foosboy_adv"
    }
  }

  dev: {
    secret: "AnoTh3rDiffrntsecr3TstrinG"
    pgsql: {
      user: "postgres"
      pass: ""
      db: "foosboy_adv_dev"
    }
  }
}

