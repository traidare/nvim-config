local M = {}

local info_name = vim.g.nix_info_plugin_name

---@type boolean
M.isNix = info_name ~= nil

--- Safe deep indexing into nixInfo with fallback
--- Usage: nix.get(default, "settings", "cats", "lua")
---@param default any Fallback value if not in nix environment or path doesn't exist
---@param ... string Path segments to index into nixInfo
---@return any
function M.get(default, ...)
  if not info_name then
    return default
  end
  local ok, nixInfo = pcall(require, info_name)
  if not ok then
    return default
  end
  return nixInfo(default, ...)
end

--- Check if category is enabled
--- Usage: nix.cat("lua") -> true/false
--- In nix: defaults to false (disabled) if category not found
--- Not in nix: defaults to true (enabled) for development
---@param category string Category name to check
---@return boolean
function M.cat(category)
  if not M.isNix then
    return true -- Development mode: enable all categories
  end
  return M.get(false, "settings", "cats", category) and true or false
end

--- Get config directory path
--- In nix environment: returns wrapped or unwrapped config path
--- Otherwise: returns stdpath("config")
---@return string
function M.configDir()
  local dir = M.get(nil, "settings", "config_directory")
  if type(dir) == "string" then
    return dir
  end
  return vim.fn.stdpath("config")
end

--- Get plugin path from nix store
--- Checks both lazy and start plugin directories
---@param name string Plugin name
---@return string|nil
function M.pluginPath(name)
  return M.get(nil, "plugins", "lazy", name) or M.get(nil, "plugins", "start", name)
end

--- Get extra info data
--- Usage: nix.info("nixdExtras", "nixpkgs")
---@param ... string Path segments within info
---@return any
function M.info(...)
  return M.get(nil, "info", ...)
end

return M
