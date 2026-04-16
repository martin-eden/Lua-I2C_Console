-- Parse string to command structure

--[[
  Author: Martin Eden
  Last mod.: 2026-04-15
]]

local <const> ItnessParser = request('!.concepts.Itness.Parser.Interface')
local <const> StringInput = request('!.concepts.StreamIo.Input.String')
local <const> TableIsEmpty = request('!.table.is_empty')

local ParseAsItness =
  function(DataStr)
    local <const> Parser = new(ItnessParser)

    local <const> StringInput = new(StringInput)
    StringInput.String = DataStr

    Parser.Input = StringInput

    local <const> ParseTree = Parser:Run()

    return ParseTree
  end

--[[
  Parse multiline string to internal command structure
]]
local ParseCommandStr =
  function(DataStr)
    local <const> Result = { Command = '', Data = {} }

    local <const> ParsedCommandData = ParseAsItness(DataStr);

    if TableIsEmpty(ParsedCommandData) then
      return Result
    end

    Result.Command = ParsedCommandData[1][1]

    for Index = 2, #ParsedCommandData[1] do
      table.insert(Result.Data, ParsedCommandData[1][Index])
    end

    return Result
  end

-- Export:
return ParseCommandStr

--[[
  2026-04-15
]]
