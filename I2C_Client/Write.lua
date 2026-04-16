-- [me_I2C_Console client] Send data to I2C device

--[[
  Author: Martin Eden
  Last mod.: 2026-04-16
]]

local <const> SendCommand = request('Internals.SendCommand')
local <const> GetData = request('Internals.GetData')
local <const> ParseCommandStr = request('Internals.ParseCommandStr')

--[[
  Write data to I2C device
]]
local I2C_Write =
  function(Io, DeviceId, DataBytes)
    assert_integer(DeviceId)
    assert_table(DataBytes)

    local <const> DataLength = #DataBytes

    local <const> RequestData = {}
    table.insert(RequestData, DeviceId)
    table.insert(RequestData, DataLength)
    for Index = 1, #DataBytes do
      table.insert(RequestData, DataBytes[Index])
    end

    local <const> Request =
      {
        Command = 'w',
        Data = RequestData,
      }
    SendCommand(Request, Io.OutputStream)
    local <const> DataStr = GetData(Io.InputStream)
    local <const> Reply = ParseCommandStr(DataStr)
    if (Reply.Command ~= 'w') then return {} end
  end

-- Export:
return I2C_Write

--[[
  2026-04-16
]]
