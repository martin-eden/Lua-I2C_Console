-- Send command structure as string

--[[
  Author: Martin Eden
  Last mod.: 2026-04-15
]]

local <const> Sleep_Secs = request('!.system.sleep')

local SendItem =
  function(Item, OutputStream)
    local <const> InteritemsSleep_Secs = .02

    OutputStream:Write(Item)
    OutputStream:Write(' ')

    Sleep_Secs(InteritemsSleep_Secs)
  end

--[[
  Send command as sequence of items

  Uses delays to give device enough time to handle data.
]]
local SendCommand =
  function(Command, OutputStream)
    SendItem(Command.Command, OutputStream)

    for Index = 1, #Command.Data do
      local <const> Item = tostring(Command.Data[Index])
      SendItem(Item, OutputStream)
    end
  end

-- Export:
return SendCommand

--[[
  2026-04-15
]]
