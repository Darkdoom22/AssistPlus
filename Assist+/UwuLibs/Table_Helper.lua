local Table_Helper = {}

function Table_Helper.get()
  self = {}
  
  
  self.has_value = function(tab, val)
    for index, value in ipairs(tab) do
       if value == val then
          return true
        end
   end
   return false
end
  
  
  return self
end
return Table_Helper.get()