-- [me_I2C_Console client] Get list of I2C devices

--[[
  Author: Martin Eden
  Last mod.: 2026-04-15
]]

local <const> SendCommand = request('Internals.SendCommand')
local <const> GetData = request('Internals.GetData')
local <const> ParseCommandStr = request('Internals.ParseCommandStr')

--[[
  Get list of available I2C devices
]]
local I2C_Scan =
  function(Io)
    local <const> Request = { Command = 's', Data = {} }
    SendCommand(Request, Io.OutputStream)
    local <const> DataStr = GetData(Io.InputStream)
    local <const> Reply = ParseCommandStr(DataStr)
    if (Reply.Command ~= 's') then return {} end

    local Result = {}
    for Index = 1, #Reply.Data do
      Result[Index] = tonumber(Reply.Data[Index])
    end

    return Result
  end

-- Export:
return I2C_Scan

--[[
  2026-04-15
]]
