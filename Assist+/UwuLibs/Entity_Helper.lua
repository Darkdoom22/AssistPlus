local Entity_Helper = {}
function Entity_Helper.get()
  self = {}
  
  self.get_name = function(player)
    return player.name
  end
  
  self.get_index = function(player)
    return player.index
  end
  
  self.get_id = function(player)
    return player.id
  end
  
  self.get_id_by_name = function(name)
    local ent = windower.ffxi.get_mob_by_name(name)
    if ent ~= nil then
    return ent.id
    end
  end
  
  self.get_status = function(player)
    return player.status
  end
  
  self.main_job = function(player)
    return player.main_job
  end
  
  self.hp = function(player)
    return player.hp
  end
  
  self.mp = function(player)
    return player.mp
  end
  
  self.tp = function(player)
    return player.tp 
  end
  
  self.hpp = function(player)
    return player.hpp
  end
  
  self.in_combat = function(player)
    return player.in_combat
  end
  
  self.target_index = function(player)
    return player.target_index
  end
  
  self.job_abilities = function()
    return windower.ffxi.get_abilities.job_abilities
  end
  
  self.weapon_skills = function()
    return windower.ffxi.get_abilities.weapon_skills
  end
  
  self.inventory_cur = function(bag)
    return windower.ffxi.get_bag_info(bag).count
  end
  
  self.inventory_total = function(bag)
    return windower.ffxi.get_bag_info(bag).max
  end
  
  self.menu_open = function()
    return windower.ffxi.get_info().menu_open
  end
  
  self.get_item = function(bag, slot, count)
    count = 1 or count
    bag = 0 or bag
    return windower.ffxi.get_item(bag, slot, count)
  end
  
  self.get_items = function(bag, index)
    bag = 0 or bag
    index = 0 or index    
    return windower.ffxi.get_items(bag, index)
  end
  
  self.get_key_items = function()
    return windower.ffxi.get_key_items()
  end
  
  self.get_party = function()
    return windower.ffxi.get_party()
  end
  
  self.get_buffs = function(player)
    return player.buffs
  end
  
  self.get_spells = function()
    return windower.ffxi.get_spells()
  end
  
  self.get_spell_recasts = function()
    return windower.ffxi.get_spell_recasts()
  end
  
  self.move_item = function(bag, slot, count)
    bag = 0 or bag
    slot = 0 or slot
    count = 1 or count
    return windower.ffxi.put_item(bag, slot, count)
  end
  
  self.move = function(target_x, player_x, target_y, player_y)
    return windower.ffxi.run(target_x - player_x, target_y - player_y)
  end
  
  self.positions = function(id)
    local positions = windower.ffxi.get_mob_by_id(id)
    local x = positions.x
    local y = positions.y
    local z = positions.z
    return x, y, z
  end
  --90 x
  --19 y
  self.cur_zone = function()
    return windower.ffxi.get_info().zone
  end
  
  self.cancel_movement = function()    
    windower.send_command('setkey numpad7 down; wait 0.3; setkey numpad7 up')
  end
  
  self.get_engaged_as_string = function(player)
    local e_a_s = ""
    if player.status == 0 then
      e_a_s = "Idle"
      return e_a_s
    elseif player.status == 1 then
      e_a_s = "Engaged"
      return e_a_s
    end
  end

  return self

  
  
end
return Entity_Helper.get()