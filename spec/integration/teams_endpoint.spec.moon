
import load_test_server, close_test_server, request from require "lapis.spec.server"
import encode, decode from require "cjson"

describe "/api/teams", ->
  test = {
    teams_list: {},
    players_list: {}
    team: {
      team_name: "Rick and Morty"
    }
  }

  setup ->
    load_test_server!
    {:Players} = require "models"
    test.players_list = Players\select!

  teardown ->
    close_test_server!

  it "should setup the test environment properly", ->
    assert.is_true #test.players_list > 2

  it "should load [GET] /api/teams/all", ->
    status, body, headers = request "/api/teams/all"
    assert.same 200, status
    assert.truthy body

    test.teams_list = decode body
    assert.truthy test.teams_list

  it "should create a team [POST] /api/teams/create", ->
    -- TODO: This test leaves a stray user in the test database, but doesn't clean up after itself
    --       therefore, the test will work on an empty database, but fail on a second attempt.
    --       Current solution is to manually empty the 'teams' table in pgsql
    status, body, headers = request "/api/teams/create", post: {
      -- TODO: (FIX) This test depends on the database having at least 2 existing users
      player1_id: test.players_list[1].id,
      player2_id: test.players_list[2].id,
      team_name: "Rick and Morty"
    }

    assert.same 200, status

