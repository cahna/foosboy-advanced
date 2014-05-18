
import mock_request from require "lapis.spec.request"

Api = require "app.api"

describe "Foosboy API", ->
  it "should exist", ->
    status, body = mock_request Api, "/"

    assert.same 200, status
    assert.truthy body\match "[Ww]elcome"

  pending "should have some functionality"

