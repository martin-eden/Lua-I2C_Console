-- Command-line tool to write data to I2C device

--[[
  Author: Martin Eden
  Last mod.: 2026-04-16
]]

-- [[ Release
require('workshop.base')
--]]
--[[ Dev
package.path = package.path .. ';../../workshop/?.lua'
require('base')
--]]

local <const> Config =
  {
    DeviceFileName = '/dev/ttyUSB0',
    DeviceId = tonumber(arg[1]),
  }

local <const> Teletype = request('!.concepts.StreamIo.Teletype.Interface')
local <const> PreflightChecks = request('I2C_Client.PreflightChecks')
local <const> I2C_Write = request('I2C_Client.Write')

local PrintHelp =
  function()
    print('Usage: <DeviceId> <Bytes+>')
  end

local Write =
  function(IoStreams, DeviceId, DataBytes)
    if is_nil(DeviceId) then
      print('DeviceId is not set')
      print('')
      PrintHelp()
      return
    end

    if not PreflightChecks(IoStreams) then
      print('We are not compatible with server.')
      return
    end

    I2C_Write(IoStreams, DeviceId, DataBytes)
  end

-- Pack command-line arguments with data
local GetDataBytes =
  function(Args)
    local <const> Result = {}
    for Index = 2, #Args do
      local <const> DataByte = tonumber(Args[Index])
      table.insert(Result, DataByte)
    end
    return Result
  end

-- Main
do
  local <const> DataBytes = GetDataBytes(_G.arg)

  Teletype:Open(Config.DeviceFileName)

  local <const> IoStreams =
    {
      InputStream = Teletype.Input,
      OutputStream = Teletype.Output,
    }

  Write(IoStreams, Config.DeviceId, DataBytes)

  Teletype:Close()
end

--[[
  2026-04-16
]]
