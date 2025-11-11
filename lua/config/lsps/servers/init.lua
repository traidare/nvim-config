local servers = {}
local servers_dir = vim.fn.stdpath("config") .. "/lua/config/lsps/servers"

for name, type in vim.fs.dir(servers_dir) do
  if name ~= "init.lua" and type == "file" and name:match("%.lua$") then
    local module = require("config.lsps.servers." .. name:gsub("%.lua$", ""))
    vim.list_extend(servers, module)
  end
end

return servers
