local M = {}

function M.on_attach(_, bufnr, server)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap("gd", vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap("K", vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap("gr", vim.lsp.buf.references, '[G]oto [R]eferences')

    nmap("[d", vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
    nmap("]d", vim.diagnostic.goto_next, 'Next [D]iagnostic')
    nmap("<leader>ad", vim.diagnostic.setloclist)

    if server == "clangd" then
        nmap("<F4>", ":ClangdSwitchSourceHeader<CR>", "Switch to Source/Header")
    end
end

function M.get_capabilities(server)
    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if nixCats('general.cmp') then
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    end
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    --vim.tbl_extend('keep', capabilities, require'coq'.lsp_ensure_capabilities())
    --vim.api.nvim_out_write(vim.inspect(capabilities))
    return capabilities
end

return M
