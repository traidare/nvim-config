local M = {}

--- Category-based conditional loading handler for lze
--- Usage in plugin spec:
---   { "plugin", for_cat = "lua" }
---   { "plugin", for_cat = { cat = "lua", default = true } }
---
--- When in nix environment: checks if category is enabled
--- When not in nix: uses `default` value if provided in table form
M.for_cat = {
  spec_field = "for_cat",
  set_lazy = false,
  modify = function(plugin)
    if nix.isNix then
      if type(plugin.for_cat) == "table" and plugin.for_cat.cat ~= nil then
        -- Use the table's default (or false if not specified) as fallback
        plugin.enabled = nix.get(plugin.for_cat.default or false, "settings", "cats", plugin.for_cat.cat) and true
          or false
      elseif type(plugin.for_cat) == "string" then
        -- String form: default to false (disabled) if category not found
        plugin.enabled = nix.get(false, "settings", "cats", plugin.for_cat) and true or false
      end
    else
      -- Non-nix fallback
      if type(plugin.for_cat) == "table" and plugin.for_cat.default ~= nil then
        plugin.enabled = plugin.for_cat.default
      end
      -- If no default specified, leave enabled as-is (defaults to true)
    end
    return plugin
  end,
}

--- Auto-enable handler that checks if plugin is available in nix store
--- Usage in plugin spec:
---   { "plugin", auto_enable = true }       -- checks plugin.name
---   { "plugin", auto_enable = "dep-name" } -- checks specific dependency
---   { "plugin", auto_enable = { "dep1", "dep2" } } -- checks all dependencies
---
--- Useful for optional plugins that may or may not be included in the build
M.auto_enable = {
  spec_field = "auto_enable",
  set_lazy = false,
  modify = function(plugin)
    if nix.isNix then
      local function has(name)
        return nix.pluginPath(name) ~= nil
      end
      if plugin.auto_enable == true then
        plugin.enabled = has(plugin.name)
      elseif type(plugin.auto_enable) == "string" then
        plugin.enabled = has(plugin.auto_enable)
      elseif type(plugin.auto_enable) == "table" then
        plugin.enabled = true
        for _, name in ipairs(plugin.auto_enable) do
          if not has(name) then
            plugin.enabled = false
            break
          end
        end
      end
    end
    -- In non-nix environment, leave enabled as-is
    return plugin
  end,
}

return M
