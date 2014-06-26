local Model
do
  local _obj_0 = require('lapis.db.model')
  Model = _obj_0.Model
end
local Players
do
  local _parent_0 = Model
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Players",
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
  self.timestamp = true
  self.create = function(self, opt)
    local first_name, last_name
    first_name, last_name = opt.first_name, opt.last_name
    if not first_name then
      return nil, "missing opt 'first_name'"
    end
    if not last_name then
      return nil, "missing opt 'last_name'"
    end
    if self:exists(opt) then
      return nil, "duplicate player name"
    end
    return Model.create(self, {
      first_name = first_name,
      last_name = last_name
    })
  end
  self.exists = function(self, opt)
    if not opt.first_name then
      return nil, "missing opt 'first_name'"
    end
    if not opt.last_name then
      return nil, "missing opt 'last_name'"
    end
    if Players:find(opt) then
      return true
    else
      return false
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Players = _class_0
end
local Teams
do
  local _parent_0 = Model
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Teams",
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
  self.timestamp = true
  self.exists_with_name = function(self, name)
    if self:find({
      team_name = name
    }) then
      return true
    end
    return false
  end
  self.exists_with_players = function(self, p1, p2)
    if not ((p1 and p2)) then
      return nil, "invalid player id"
    end
    if self:find({
      player1_id = p1,
      player2_id = p2
    }) then
      return true
    end
    if self:find({
      player1_id = p2,
      player2_id = p1
    }) then
      return true
    end
    return false
  end
  self.create = function(self, opt)
    local player1_id, player2_id
    player1_id, player2_id = opt.player1_id, opt.player2_id
    local team_name = opt.team_name or "Unnamed Team - " .. tostring(player1_id) .. " and " .. tostring(player2_id)
    if not player1_id then
      return nil, "missing opt, 'player1_id'"
    end
    if not player2_id then
      return nil, "missing opt, 'player2_id'"
    end
    if not Players:find({
      id = player1_id
    }) then
      return nil, "player1 id does not exist"
    end
    if not Players:find({
      id = player2_id
    }) then
      return nil, "player2 id does not exist"
    end
    return Model.create(self, {
      team_name = team_name,
      player1_id = player1_id,
      player2_id = player2_id
    })
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Teams = _class_0
end
local Matches
do
  local _parent_0 = Model
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Matches",
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
  self.timestamp = true
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Matches = _class_0
end
return {
  Teams = Teams,
  Players = Players,
  Matches = Matches
}
