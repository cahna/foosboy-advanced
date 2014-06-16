
--import mock_request from require "lapis.spec.request"
import load_test_server, close_test_server from require "lapis.spec.server"
import Teams, Players from require "models"

import dump, write from require "pl.pretty"

describe "Teams model tests", ->
  setup ->
    load_test_server!

  teardown ->
    close_test_server!

  local test_player1, test_player2
  test_vars = {
    team_name: "Dream team"
    player1: {
      first_name: tostring os.time!
      last_name: tostring(os.time!)\reverse!
    },
    player2: {
      first_name: tostring(os.time!)\reverse!
      last_name: tostring os.time!
    }
  }

  it "creates users for a team", ->
    test_player1 = Players\create test_vars.player1
    test_player2 = Players\create test_vars.player2

    assert.truthy test_player1
    assert.truthy test_player2

    assert.same test_vars.player1.first_name, test_player1.first_name
    assert.same test_vars.player1.last_name, test_player1.last_name
    assert.same test_vars.player2.first_name, test_player2.first_name
    assert.same test_vars.player2.last_name, test_player2.last_name

    assert.is_true Players\exists test_vars.player1
    assert.is_true Players\exists test_vars.player2

    assert.is_true type(test_vars.team_name) == "string"

  it "creates a team with the 2 users", ->
    assert.truthy test_player1
    assert.truthy test_player2

    team = Teams\create {
      player1_id: test_player1.id,
      player2_id: test_player2.id
    }

    assert.truthy team

    Players\include_in team, "player1_id"
    Players\include_in team, "player2_id"

    assert.truthy team.player1
    assert.truthy team.player2

