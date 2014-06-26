local Application
do
  local _obj_0 = require("lapis")
  Application = _obj_0.Application
end
local Teams
do
  local _obj_0 = require("models")
  Teams = _obj_0.Teams
end
local respond_to, yield_error, json_params, assert_error, capture_errors_json
do
  local _obj_0 = require("lapis.application")
  respond_to, yield_error, json_params, assert_error, capture_errors_json = _obj_0.respond_to, _obj_0.yield_error, _obj_0.json_params, _obj_0.assert_error, _obj_0.capture_errors_json
end
local assert_valid, validate_functions
do
  local _obj_0 = require("lapis.validate")
  assert_valid, validate_functions = _obj_0.assert_valid, _obj_0.validate_functions
end
validate_functions.matches = function(input, pattern)
  input = tostring(input)
  return input and input:match(pattern)
end
local TeamsApp
do
  local _parent_0 = Application
  local _base_0 = {
    [{
      list = "/all"
    }] = capture_errors_json(function(self)
      return {
        json = {
          payload = Teams:select()
        }
      }
    end),
    [{
      create = "/create"
    }] = respond_to({
      POST = capture_errors_json(function(self)
        require("pl.pretty").dump(self.params)
        assert_valid(self.params, {
          {
            "player1_id",
            exists = true,
            type = "string"
          },
          {
            "player2_id",
            exists = true,
            type = "string"
          },
          {
            "team_name",
            type = "string"
          }
        })
        if Teams:exists_with_players(self.params.player1_id, self.params.player2_id) then
          return {
            status = 500,
            json = {
              errors = {
                "Those players are already on a team"
              }
            }
          }
        end
        if self.params.team_name and Teams:exists_with_name(self.params.team_name) then
          return {
            status = 500,
            json = {
              errors = {
                "A team already exists with that name"
              }
            }
          }
        end
        local team = assert_error(Teams:create({
          player1_id = self.params.player1_id,
          player2_id = self.params.player2_id,
          team_name = self.params.team_name
        }))
        return {
          status = 200,
          json = team
        }
      end)
    })
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TeamsApp",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.layout = false
  self.path = "teams"
  self.name = "team_"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TeamsApp = _class_0
  return _class_0
end
