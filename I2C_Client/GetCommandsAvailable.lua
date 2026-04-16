-- [me_I2C_Console client] Get list of commands

--[[
  Author: Martin Eden
  Last mod.: 2026-04-15
]]

--[[
  [me_I2C_Console] outputs in Itness-compatible text format

  After connection it writes greeting line and result of List command:

    > I2C console
    > ( ?
    >   ? - List commands
    >   ^ - Exit
    >   s - Scan
    >   r - Read <DeviceId> <NumBytes>
    >   w - Write <DeviceId> <NumBytes> <Bytes+>
    > )

  We want to parse it to like

    { Command = '?', Data = { '?', '^', 's', 'r', 'w' } }

  We will remove greeting line and parse command block.
  Command block starts with line with "( " and command name.
  Then lines with command name and maybe " - " with description.
  Last line is ")".
]]

local <const> GetData = request('Internals.GetData')
local <const> SendCommand = request('Internals.SendCommand')
local <const> Lines = request('!.concepts.Lines.Interface')
local <const> ParseCommandStr = request('Internals.ParseCommandStr')

local LooksLikeGreeting =
  function(Lines)
    local <const> FirstLine = Lines:GetLineAt(1)

    return (string.sub(FirstLine, 1, 1) ~= '(')
  end

local RemoveGreeting =
  function(Lines)
    Lines:RemoveLineAt(1)
  end

local RemoveDescription =
  function(CommandDescStr)
    local CommandStr

    local <const> DescIdx = string.find(CommandDescStr, " - ", 1, true)
    if DescIdx then
      CommandStr = string.sub(CommandDescStr, 1, DescIdx - 1)
    else
      CommandStr = CommandDescStr
    end

    return CommandStr
  end

local RemoveDescriptions =
  function(Lines)
    for LineNum = 2, Lines:GetNumLines() - 1 do
      local <const> CommandDescStr = Lines:GetLineAt(LineNum)
      local <const> CommandStr = RemoveDescription(CommandDescStr)
      Lines:SetLineAt(CommandStr, LineNum)
    end
  end

--[[
  Get list of available commands
]]
local GetCommandsAvailable =
  function(Io)
    --[[
      Currently after connection board prints list of commands

      It is printed same way as if List command "?" was entered.

      If we have data, we will try to parse it as list of commands
      (data will contain greeting line we will remove).
      If not, we will emit "?" and parse output.
    ]]

    local DataStr

    DataStr = GetData(Io.InputStream)

    if (DataStr == '') then
      local <const> Request = { Command = '?', Data = {} }
      SendCommand(Request, Io.OutputStream)
      DataStr = GetData(Io.InputStream)
    end

    local <const> Lines = new(Lines)
    Lines:FromString(DataStr)

    if LooksLikeGreeting(Lines) then
      RemoveGreeting(Lines)
    end

    RemoveDescriptions(Lines)

    DataStr = Lines:ToString()

    local <const> Command = ParseCommandStr(DataStr)

    if (Command.Command ~= '?') then return {} end

    local <const> Result = new(Command.Data)
    table.sort(Result)

    return Result
  end

-- Export:
return GetCommandsAvailable

--[[
  2026-04-15
]]
