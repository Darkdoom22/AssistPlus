local W_Input = {}

function W_Input.get()
  self = {}
  
  self.chat = function(text)
  windower.chat.input(text)
  end

  self.message = function(mode, text)
    windower.add_to_chat(mode, text)
  end
  
  return self
end
return W_Input.get()
  