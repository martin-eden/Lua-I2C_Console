-- [me_I2C_Console client] Get device data

--[[
  Author: Martin Eden
  Last mod.: 2026-04-16
]]

local <const> SendCommand = request('Internals.SendCommand')
local <const> GetData = request('Internals.GetData')
local <const> ParseCommandStr = request('Internals.ParseCommandStr')

--[[
  Get data from I2C device
]]
local I2C_Read =
  function(Io, DeviceId, DataLength)
    assert_integer(DeviceId)
    assert_integer(DataLength)

    local <const> Request =
      {
        Command = 'r',
        Data = { DeviceId, DataLength },
      }
    SendCommand(Request, Io.OutputStream)
    local <const> DataStr = GetData(Io.InputStream)
    local <const> Reply = ParseCommandStr(DataStr)
    if (Reply.Command ~= 'r') then return {} end

    local <const> Result = {}
    for Index = 1, #Reply.Data do
      Result[Index] = tonumber(Reply.Data[Index])
    end

    return Result
  end

-- Export:
return I2C_Read

--[[
  2026-04-15
  2026-04-16
]]
