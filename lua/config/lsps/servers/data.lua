return {
  { "jsonls", for_cat = "serde", lsp = {} },
  {
    "yamlls",
    for_cat = "serde",
    lsp = {
      filetypes = { "yaml", "yml" },
      settings = {
        yaml = {
          schemas = {
            ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
            ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master"] = "/*.k8s.yaml",
          },
        },
        redhat = { telemetry = { enabled = false } },
      },
    },
  },
  { "gitlab_ci_ls", for_cat = "serde", lsp = {} },
}
