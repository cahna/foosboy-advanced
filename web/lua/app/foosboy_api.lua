local Application
do
  local _obj_0 = require("lapis")
  Application = _obj_0.Application
end
local respond_to, assert_error, capture_errors_json
do
  local _obj_0 = require("lapis.application")
  respond_to, assert_error, capture_errors_json = _obj_0.respond_to, _obj_0.assert_error, _obj_0.capture_errors_json
end
local encode
do
  local _obj_0 = require("cjson")
  encode = _obj_0.encode
end
local FoosboyApi
do
  local _parent_0 = Application
  local _base_0 = {
    handle_404 = function(self)
      return {
        status = 404,
        json = {
          errors = {
            {
              "Unknown route",
              tostring(self.req.cmd_url)
            }
          }
        }
      }
    end,
    default_route = capture_errors_json(function(self)
      if self.req.parsed_url.path:match("./$") then
        local stripped = self.req.parsed_url.path:match("^(.+)/+$")
        return {
          redirect_to = self:build_url(stripped, {
            query = self.req.parsed_url.query
          }),
          status = 301
        }
      else
        ngx.log(ngx.NOTICE, "User hit unknown path " .. tostring(self.req.parsed_url.path))
        return self.app.handle_404(self)
      end
    end),
    [{
      index = "/"
    }] = function(self)
      return "Welcome to Foosboy-Advanced on Lapis " .. tostring(require("lapis.version")) .. "!"
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "FoosboyApi",
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
  self:include("app.players", {
    path = "/api/players"
  })
  self:include("app.teams", {
    path = "/api/teams"
  })
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  FoosboyApi = _class_0
  return _class_0
end
