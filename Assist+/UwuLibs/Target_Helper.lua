local Target_Helper = {}
function Target_Helper.get()
  self = {}
  packets = require('packets')
  self.face = function(actor)
    local target = {}
    local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
    if actor then
        target = actor
    else 
        target = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().target_index or 0)
    end
    if target then
    local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
    windower.ffxi.turn((angle):radian())
    end
  end
  
  self.engage_target = 	function(target)
  local Engage = packets.new('outgoing', 0x01A, {
	['Target'] = target.id,
	['Target Index'] = target.index,
	['Category'] = 2,
  })
  return Engage
  end
  
  self.target_id = function(target)
    local target_id = target.id
    return target_id
  end

  self.target_hpp = function(target)
    local target_hpp = target.hpp
    return target_hpp
  end
  
  self.target_distance = function(target)
    local target_distance = math.sqrt(target.distance)
    return target_distance
  end
  
  self.get_target = function()
    local target = windower.ffxi.get_mob_by_target('t')
    return target
  end
  
  self.get_battle_target = function()
    local target = windower.ffxi.get_mob_by_target('bt')
    return target
  end
  
  self.valid = function(target)
    local valid = target.valid_target
    return valid
  end
  
  return self
end
return Target_Helper.get()