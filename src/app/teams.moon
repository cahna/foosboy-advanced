
import Application from require "lapis"
import Teams from require "models"
import respond_to, yield_error, json_params, assert_error, capture_errors_json from require "lapis.application"
import assert_valid, validate_functions from require "lapis.validate"

validate_functions.matches = (input, pattern) ->
  input = tostring input
  input and input\match pattern

class TeamsApp extends Application
  @layout: false
  @path: "teams"
  @name: "team_"

  [list: "/all"]: capture_errors_json =>
    json: {
      payload: Teams\select!
    }

--  [view: "/view/:id"]: respond_to {
--    GET: json_params capture_errors_json =>
--      assert_valid @params, {{ "id", type: "string"}}
--      status: 200, json: {payload: Players\find id: @params.id}
--  }

  [create: "/create"]: respond_to {
    POST: capture_errors_json =>
      require"pl.pretty".dump @params
      assert_valid @params, {
        { "player1_id", exists: true, type: "string" }
        { "player2_id", exists: true, type: "string" }
        { "team_name", type: "string" }
      }

      if Teams\exists_with_players @params.player1_id, @params.player2_id
        return status: 500, json: {
          errors: {"Those players are already on a team"}
        }

      if @params.team_name and Teams\exists_with_name @params.team_name
        return status: 500, json: {
          errors: {"A team already exists with that name"}
        }

      team = assert_error Teams\create {
        player1_id: @params.player1_id
        player2_id: @params.player2_id
        team_name: @params.team_name
      }

      status: 200, json: team
  }
