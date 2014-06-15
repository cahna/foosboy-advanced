
--import mock_request from require "lapis.spec.request"
import load_test_server, close_test_server from require "lapis.spec.server"
import Players from require "models"

import dump, write from require "pl.pretty"

describe "Players model tests", ->
  setup ->
    load_test_server!

  teardown ->
    close_test_server!

  test_vars = {
    first_name: tostring os.time()
    last_name: tostring(os.time())\reverse!
  }

  it "user #{write test_vars} does not exist at first", ->
    assert.is_false Players\exists test_vars

  it "user #{write test_vars} is created", ->
    assert.truthy Players\create test_vars

  it "user #{write test_vars} now exists", ->
    assert.is_true Players\exists test_vars

