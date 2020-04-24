_addon.name = "Assist+"
_addon.author = "Uwu/Darkdoom"
_addon.version = "1.0a"
_addon.command = "ass"

Entity_Helper = require('UwuLibs/Entity_Helper')
Target_Helper = require('UwuLibs/Target_Helper')
Table_Helper = require('UwuLibs/Table_Helper')
W_Input = require('UwuLibs/W_Input')
require('default_settings')
packets = require('packets')
texts = require('texts')

Assist_Timer = os.clock()
Running = false
Player_Lead_ID = 0
Player_Lead_Name = ""
Use_Leader = true
Claimer_ID = 0
Chars = {}
Settings = (defaults)
Status_Box = texts.new(Settings.player)
  
  windower.register_event('load', function()
      
      W_Input.message(17, "   ~Assist+ Commands~\n" .. "//ass start - Turn On\n" .. "//ass stop - Turn Off\n" .. "//ass name <name> - Set Assist Leader\n" .. "//ass leader on/off - Switch between Leader Assist and Free Assist")
  
  end)
  
  
windower.register_event('addon command', function(...)
  
  local args = {...}
    
  if #args == 1 and args[1]:lower() == "start" then
      
    Running = true
    W_Input.message(17, "Assist+ is now running!")
    
  elseif #args == 1 and args[1]:lower() == "stop" then
    
    Running = false
    W_Input.message(17, "Assist+ is now stopped!")
    
  elseif #args == 2 and args[1]:lower() == "name" then
        
    Player_Lead_Name = args[2]
    W_Input.message(17, "Assist Leader set to: " .. args[2])
    
  elseif #args == 2 and args[1]:lower() == "leader" and args[2] == "on" then
    
    if Use_Leader == false then
      Use_leader = true
      W_Input.message(17, "Assist+ is now in Leader Assist mode")
    elseif Use_Leader == true then
      W_Input.message(17, "Assist+ is already in Leader Assist mode")
    end
  
  elseif #args == 2 and args[1]:lower() == "leader" and args[2] == "off" then
    
    if Use_Leader == true then
      Use_Leader = false
      W_Input.message(17, "Assist+ is now in Free Assist mode")
    elseif Use_Leader == false then
      W_Input.message(17, "Assist+ is already in Free Assist mode")
    end
    
  end
    
end)


windower.register_event('incoming chunk', function(id, original)
    
    if id == 0x00E and Running == true and Use_Leader == true then
      
      local p = packets.parse('incoming', original)
      local claim_id = p["Claimer"]

      if claim_id ~= nil and claim_id == Player_Lead_ID then
        
      Claimer_ID = claim_id
      
      end
      
    end
    
  end)


windower.register_event('ipc message', function(msg)

  local modified = ""
  local ret_mod = ""
  
  if msg:sub(-1) == "0" then
    
    modified = msg:gsub("0","")
    ret_mod = modified .. "Idle"
    
    if not Table_Helper.has_value(Chars, ret_mod) then
    
    table.insert(Chars, ret_mod)
  
    end
    
  elseif msg:sub(-1) == "1" then
    
    modified = msg:gsub("1","")
    ret_mod = modified .. "Engaged"
    
    if not Table_Helper.has_value(Chars, ret_mod) then
    
    table.insert(Chars, ret_mod)
  
    end
  
  end
  
  for k,v in pairs(Chars) do
    
    if ret_mod:sub(-4) ~= Chars[k]:sub(-4) and ret_mod:sub(1, 3) == Chars[k]:sub(1, 3) then
      
      table.remove(Chars, k)
      
    end
    
  end
  
end)


function Display_Box()
  
  local string = table.concat(Chars,"\n")
  
  if Chars ~= nil then
   
    local player = windower.ffxi.get_player()
    local engage_text = "Char   |   Status\n" .. Entity_Helper.get_name(player) .. " ~ " .. Entity_Helper.get_engaged_as_string(player) .. "\n" .. string
    
    if engage_text ~= nil then
      
      Status_Box:text(engage_text)
      Status_Box:visible(true)
    
    end
  
  end

end


function Validate_Assist_Player()

  local player = windower.ffxi.get_player()
  
  if player ~= nil then

    if Player_Lead_Name ~= nil then
      
      Player_Lead_ID = Entity_Helper.get_id_by_name(Player_Lead_Name)
      
      if Player_Lead_ID ~= nil then
        
        return true
        
      end
      
    end
    
  end
  
  return false
  
end

function Assist()

 
  if Validate_Assist_Player() == true and Running == true and Use_Leader == true then
    
    local cur_mob = windower.ffxi.get_mob_by_target('bt')
    local player = windower.ffxi.get_player()
    local status = Entity_Helper.get_status(player)
    
    if cur_mob ~= nil then
      
      if Target_Helper.valid(cur_mob) == false then
        
      cur_mob = 0
      
    end
    
  end
    
    if cur_mob ~= nil and Target_Helper.valid(cur_mob) == true and Claimer_ID == Player_Lead_ID and status == 0 and Target_Helper.target_distance(cur_mob) < 20 and Use_Leader == true then

    local Engage = Target_Helper.engage_target(cur_mob)
    packets.inject(Engage)

    elseif cur_mob ~= nil and Target_Helper.valid(cur_mob) == true and Target_Helper.target_distance(cur_mob) < 15 and Use_Leader == false then
    
    local Engage = Target_Helper.engage_target(cur_mob)
    packets.inject(Engage)
    
    end
    
    if status == 0 then
      
      windower.send_ipc_message(Entity_Helper.get_name(player) .. " ~ " .. status)
      Entity_Helper.cancel_movement()
      
    end
    
    if cur_mob ~= nil and Target_Helper.valid(cur_mob) == true and Claimer_ID == Player_Lead_ID and status == 1 then
      
      windower.send_ipc_message(Entity_Helper.get_name(player) ..  " ~ " .. status)
      
      if Target_Helper.target_distance(cur_mob) >= 1.3 then
      
        W_Input.chat("/follow")
        Target_Helper.face(cur_mob)
              
      end
      
    end
    
  end
  
end


windower.register_event('prerender', function()
    
    if os.clock() - Assist_Timer > math.random(0.7, 1.5) and Running == true then
      
      Assist()
      Display_Box()
      Assist_Timer = os.clock()
      
    end
    
end)