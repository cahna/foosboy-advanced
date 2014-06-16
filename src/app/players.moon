
import Application from require "lapis"
import Players from require "models"
import respond_to, yield_error, json_params, assert_error, capture_errors_json from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"

validate_functions.matches = (input, pattern) ->
  input = tostring input
  input and input\match pattern

class PlayersApp extends Application
  @layout: false
  @path: "players"
  @name: "player_"

  [list: "/all"]: capture_errors_json =>
    json: {
      payload: Players\select "*"
    }

  [view: "/view/:id"]: respond_to {
    GET: json_params capture_errors_json =>
      assert_valid @params, {{ "id", type: "string"}}
      status: 200, json: {payload: Players\find id: @params.id}
  }

  [create: "/create"]: respond_to {
    POST: capture_errors_json =>
      assert_valid @params, {
        { "first_name", exists: true, type: "string" }
        { "last_name",  exists: true, type: "string" }
      }
      user = assert_error Players\create {
        first_name: @params.first_name,
        last_name: @params.last_name
      }
      status: 200, json: user
  }

  [delete: "/delete/:id"]: respond_to {
    DELETE: json_params capture_errors_json =>
      assert_valid @params, {{ "id", exists: true, type: "string" }}
      user = assert_error Players\find {id: @params.id}
      if user\delete! and not (Players\find {id: @params.id})
        return json: {messages: {"Success"}}
      else
        status: 400, json: {errors: {"Failed to delete user", @params.id}}
  }

  [update: "/update/:id"]: =>
    "Update player #{@params.id}"

