
import Application from require "lapis"
import Players from require "models"
import respond_to, json_params, assert_error, capture_errors_json from require "lapis.application"
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

  [view: "/view/:id"]: =>
    "View player #{@params.id}"

  [create: "/create"]: respond_to {
    POST: json_params capture_errors_json =>
      assert_valid @params, {
        { "first_name", exists: true, type: "string" }
        { "last_name",  exists: true, type: "string" }
      }

      {:first_name, :last_name} = @params

      user = assert_error Players\create { :first_name, :last_name }
      json: user

    GET: capture_errors_json =>
      @write status:401, json: {"test"}
  }

  [update: "/update/:id"]: =>
    "Update player #{@params.id}"

  [delete: "/delete/:id"]: =>
    "Players app #{@params.id}"
