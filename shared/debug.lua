--- Debug class with methods for printing formatted debug messages
---@class Debug
local Debug = {}

--- Extracts the filename from a path string.
---@param path string The path string to extract the filename from.
---@return string The filename extracted from the path string.
local function getOnlyFilenameFromPath(path)
    local filename = path:match("/(.+)$")
    return filename or path
end


--- Prints a formatted debug message, if debug mode is enabled.
---@param fmt string The `printf`-style format string.
---@vararg any Additional arguments to be formatted into the format string.
---@return void
function Debug:printf(fmt, ...)
    local infoWithPath = debug.getinfo(1)
    local args = {...}
    --local tableCollect = {}
    if Config.debug_mode then
        if #args > 0 then
            print(string.format("[%s] ", getOnlyFilenameFromPath(infoWithPath.short_src))..(fmt):format(...))
        else
            print("missing args ", fmt)
        end
    end
end

--- Creates a new instance of the Debug class.
---@return Debug The new instance of the Debug class.
exports('Debug', function()
    return Debug
end)
