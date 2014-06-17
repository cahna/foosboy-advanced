
import load_test_server, close_test_server from require "lapis.spec.server"
import Teams, Players from require "models"

describe "Teams model tests", ->
  setup ->
    load_test_server!

  teardown ->
    close_test_server!

  local test_player1, test_player2, test_team, test_response_message
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

  it "verifies test_playerX variables persist across serially-run tests", ->
    assert.truthy test_player1
    assert.truthy test_player2

  it "creates a team with the 2 users", ->
    test_team, test_response_message = Teams\create {
      player1_id: test_player1.id,
      player2_id: test_player2.id
    }

  it "received a valid response Team object", ->
    assert.truthy test_team
    assert.truthy test_team.id
    assert.truthy test_team.updated_at
    assert.truthy test_team.created_at
    assert.truthy test_team.player1_id
    assert.truthy test_team.player2_id
    assert.truthy test_team.team_name

  pending "can preload object associations", ->
    Players\include_in test_team, "player1_id"
    Players\include_in test_team, "player2_id"

    assert.truthy test_team.player1
    assert.truthy test_team.player2

  it "can find the new team row in the database", ->
    assert.truthy Teams\find id: test_team.id

  it "can delete the just-created team from the database", ->
    assert.truthy (Teams\find id:test_team.id)\delete!

  it "verifies that the record cannot be found in the database", ->
    assert.falsy Teams\find id:test_team.id

