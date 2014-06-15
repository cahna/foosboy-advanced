
import mock_request from require "lapis.spec.request"

import dump from require "pl.pretty"

Api = require "app.foosboy_api"

describe "Foosboy API", ->
  it "/ should exist", ->
    status, body = mock_request Api, "/"

    assert.same 200, status
    assert.truthy body\match "[Ww]elcome"

describe "/api/players", ->
  it "creates a new player", ->
    status, body = mock_request Api, "/api/players/create/", {
      first_name: "Conor",
      last_name: "Heine"
    }
    dump body
    assert.is_true status >= 200 and status < 400

  it "fails to create a new player if missing first_name or last_name", ->
    status, body = mock_request Api, "/api/players/create", {
      first_name: "Jim"
    }
    dump body
    assert.not_same 200, status

  pending "updates a player", ->
    status, body = mock_request Api, "/players/1"
    assert.same 200, status

  pending "views a player", ->
    status, body = mock_request Api, "/players/1"
    assert.same 200, status

  pending "deletes a player", ->
    status, body = mock_request Api, "/players/1"
    assert.same 200, status

