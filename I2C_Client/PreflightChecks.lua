-- Check that we are compatible with server

--[[
  Author: Martin Eden
  Last mod.: 2026-04-14
]]

local <const> GetCommandsAvailable = request('GetCommandsAvailable')
local <const> ListContains = request('!.concepts.List.Contains')

local PreflightChecks =
  function(IoStreams)
    local <const> CommandsRequired = { '?', 'r', 'w', 's' }
    local <const> CommandsAvailable = GetCommandsAvailable(IoStreams)
    if not ListContains(CommandsAvailable, CommandsRequired) then
      return false
    end
    return true
  end

-- Export:
return PreflightChecks

--[[
  2026-04-14
]]
