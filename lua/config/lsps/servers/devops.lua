return {
  { "docker_compose_language_service", for_cat = "docker", lsp = {} },
  { "dockerls", for_cat = "docker", lsp = {} },
  {
    "sqls",
    for_cat = "sql",
    lsp = {
      cmd = { "sqls", "-config", "/home/user/.config/sqls/config.yaml" },
      root_markers = { ".git", ".sqls.yml" },
    },
  },
}
