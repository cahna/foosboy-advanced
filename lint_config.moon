-- Use this file to configure which global references are allowed by the linter
whitelist_globals: {
  ["src/"]: {
    "ngx"
  }
  ["config.moon"]: {
    "port"
    "daemon"
    "secret"
    "session_name"
    "user"
    "host"
    "password"
    "database"
    "lua_code_cache"
    "num_workers"
    "postgres"
  }
  ["spec/"]: {
    "it"
    "describe"
    "setup"
    "teardown"
    "before_each"
    "after_each"
    "pending"
  }
}
