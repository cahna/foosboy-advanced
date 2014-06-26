local Application
do
  local _obj_0 = require("lapis")
  Application = _obj_0.Application
end
local Players
do
  local _obj_0 = require("models")
  Players = _obj_0.Players
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
local PlayersApp
do
  local _parent_0 = Application
  local _base_0 = {
    [{
      list = "/all"
    }] = capture_errors_json(function(self)
      return {
        json = {
          payload = Players:select()
        }
      }
    end),
    [{
      view = "/view/:id"
    }] = respond_to({
      GET = json_params(capture_errors_json(function(self)
        assert_valid(self.params, {
          {
            "id",
            type = "string"
          }
        })
        return {
          status = 200,
          json = {
            payload = Players:find({
              id = self.params.id
            })
          }
        }
      end))
    }),
    [{
      create = "/create"
    }] = respond_to({
      POST = capture_errors_json(function(self)
        assert_valid(self.params, {
          {
            "first_name",
            exists = true,
            type = "string"
          },
          {
            "last_name",
            exists = true,
            type = "string"
          }
        })
        if Players:exists({
          first_name = self.params.first_name,
          last_name = self.params.last_name
        }) then
          return {
            status = 500,
            json = {
              errors = {
                "Player already exists with that name"
              }
            }
          }
        end
        local user = assert_error(Players:create({
          first_name = self.params.first_name,
          last_name = self.params.last_name
        }))
        return {
          status = 200,
          json = user
        }
      end)
    }),
    [{
      delete = "/delete/:id"
    }] = respond_to({
      DELETE = json_params(capture_errors_json(function(self)
        assert_valid(self.params, {
          {
            "id",
            exists = true,
            type = "string"
          }
        })
        local user = assert_error(Players:find({
          id = self.params.id
        }))
        if user:delete() and not (Players:find({
          id = self.params.id
        })) then
          return {
            json = {
              messages = {
                "Success"
              }
            }
          }
        else
          return {
            status = 400,
            json = {
              errors = {
                "Failed to delete user",
                self.params.id
              }
            }
          }
        end
      end))
    }),
    [{
      update = "/update/:id"
    }] = function(self)
      return "Update player " .. tostring(self.params.id)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "PlayersApp",
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
  self.path = "players"
  self.name = "player_"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  PlayersApp = _class_0
  return _class_0
end
