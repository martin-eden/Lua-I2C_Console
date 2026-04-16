-- Command-line tool to list available I2C devices

--[[
  Author: Martin Eden
  Last mod.: 2026-04-16
]]

package.path = package.path .. ';../../workshop/?.lua'
require('base')

local <const> Config =
  {
    DeviceFileName = '/dev/ttyUSB0',
  }

local <const> Teletype = request('!.concepts.StreamIo.Teletype.Interface')
local <const> PreflightChecks = request('I2C_Client.PreflightChecks')
local <const> I2C_Scan = request('I2C_Client.Scan')

local <const> Scan =
  function(IoStreams)
    if not PreflightChecks(IoStreams) then
      print('We are not compatible with server.')
      return
    end

    local <const> DevicesAvailable = I2C_Scan(IoStreams)

    local <const> DevicesStr = table.concat(DevicesAvailable, ' ')
    print(DevicesStr)
  end

-- Main
do
  Teletype:Open(Config.DeviceFileName)

  local <const> IoStreams =
    {
      InputStream = Teletype.Input,
      OutputStream = Teletype.Output,
    }

  Scan(IoStreams)

  Teletype:Close()
end

--[[
  2026-04-15
]]
