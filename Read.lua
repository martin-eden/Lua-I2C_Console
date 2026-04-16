-- Command-line tool to read data from I2C device

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
    DataLength = tonumber(arg[2]),
  }

local <const> Teletype = request('!.concepts.StreamIo.Teletype.Interface')
local <const> PreflightChecks = request('I2C_Client.PreflightChecks')
local <const> I2C_Read = request('I2C_Client.Read')

local PrintHelp =
  function()
    print('Usage: <DeviceId> <NumBytes>')
  end

local Read =
  function(IoStreams, DeviceId, DataLength)
    local BadArgs = false

    if is_nil(DeviceId) then
      print('DeviceId is not set')
      BadArgs = true
    end

    if is_nil(DataLength) then
      print('NumBytes is not set')
      BadArgs = true
    end

    if BadArgs then
      print('')
      PrintHelp()
      return
    end

    if not PreflightChecks(IoStreams) then
      print('We are not compatible with server.')
      return
    end

    local <const> DeviceData = I2C_Read(IoStreams, DeviceId, DataLength)

    local <const> DeviceDataStr = table.concat(DeviceData, ' ')
    print(DeviceDataStr)
  end

-- Main
do
  Teletype:Open(Config.DeviceFileName)

  local <const> IoStreams =
    {
      InputStream = Teletype.Input,
      OutputStream = Teletype.Output,
    }

  Read(IoStreams, Config.DeviceId, Config.DataLength)

  Teletype:Close()
end

--[[
  2026-04-15
]]
