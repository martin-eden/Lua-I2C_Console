-- Get available data

--[[
  Author: Martin Eden
  Last mod.: 2026-04-15
]]

--[[
  Get available data from input stream as string
]]
local GetData =
  function(InputStream)
    local DataStr = ''
    local <const> BlockSize = 500

    repeat
      local ChunkStr, IsOk = InputStream:Read(BlockSize)
      DataStr = DataStr .. ChunkStr
    until not IsOk

    return DataStr
  end

-- Export:
return GetData

--[[
  2026-04-15
]]
