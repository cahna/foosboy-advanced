
db = require "lapis.db"
migrations = require "lapis.db.migrations"
import create_table, create_index, drop_table, types from require "lapis.db.schema"

{
  :serial,
  :text,
  :varchar,
  :boolean
  :time,
  :integer,
  :foreign_key
} = types

schema = {
  players: {
    {"id", serial primary_key: true}
    {"first_name", varchar}
    {"last_name", varchar}
    {"created", time}
    {"last_updated", time}
  },
  teams: {
    {"id", serial primary_key: true}
    {"team_name", varchar}
    {"player1_id", foreign_key}
    {"player2_id", foreign_key}
    {"created", time}

    -- Don't allow player1 to be the same as player2
    "CHECK (player1_id <> player2_id)"
  },
  matches: {
    {"id", serial primary_key: true}
    {"team1_id", foreign_key}
    {"team2_id", foreign_key}
    {"created", integer}

    -- Don't allow team1 to be the same as team2
    "CHECK (team1_id <> team2_id)"
  },
  games: {
    {"id", serial}
    {"match_id", foreign_key}
    {"team1_score", integer}
    {"team2_score", integer}
    {"created", time}
    {"last_updated", time}
  },
  player_postitions: {
    {"player_id", foreign_key}
    {"game_id", foreign_key}
    {"position", integer}
  }
}

create_schema = ->
  for name,definition in pairs schema
    create_table name,definition

destroy_schema = ->
  for name in *schema
    drop_table name

if ... == "test"
  db.query = print
  make_schema!

{:create_schema, :destroy_schema}

