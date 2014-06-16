
--import mock_request from require "lapis.spec.request"
import load_test_server, close_test_server from require "lapis.spec.server"
import Players from require "models"

import dump, write from require "pl.pretty"

describe "Players model tests", ->
  setup ->
    load_test_server!

  teardown ->
    close_test_server!

  local test_player_id
  test_vars = {
    first_name: tostring os.time()
    last_name: tostring(os.time())\reverse!
  }

  describe "creating a user", ->
    it "makes sure test_user doesn't already exist", ->
      assert.is_false Players\exists test_vars

    it "creates the test_user", ->
      player = Players\create test_vars
      assert.truthy player
      test_player_id = player.id

    it "ensures the test_user exists in the DB", ->
      assert.is_true Players\exists test_vars

    it "fails trying to create a user with the same name", ->
      status, msg = Players\create test_vars
      assert.falsy status
      assert.equal msg, "duplicate player name"

  describe "viewing a user", ->
    it "can view a user given a known id", ->
      assert.truthy Players\find {id: test_player_id}

  describe "deleting a player", ->
    local test_user

    it "makes sure test_user still exists", ->
      assert.is_true Players\exists test_vars

    it "can fetch the test_user", ->
      test_user = Players\find {id: test_player_id}
      assert.truthy test_user

    it "deletes the test_user", ->
      assert.truthy test_user\delete!

    it "can no longer locate the test_user", ->
      assert.is_false Players\exists test_vars

