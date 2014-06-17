
import load_test_server, close_test_server, request from require "lapis.spec.server"

describe "/api/teams", ->
  setup ->
    load_test_server!

  teardown ->
    close_test_server!

  it "should load /api/teams/all", ->
    status, body, headers = request "/api/teams/all"
    assert.same 200, status

