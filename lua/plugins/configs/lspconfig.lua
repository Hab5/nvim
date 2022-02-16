local lspconfig = pcall(require, "lspconfig")

if not (lspconfig) then
    return
end

-- replace the default lsp diagnostic symbols
local function lspSymbol(name, icon)
    vim.fn.sign_define("LspDiagnosticsSign" .. name, {
        text = icon, numhl = "LspDiagnosticsDefaul" .. name })
end

lspSymbol("Error",       " ")
lspSymbol("Warning",     "𥉉")
lspSymbol("Information", " ")
lspSymbol("Hint",        " ")

local popup_border = {
    {"╭", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╮", "FloatBorder"},
    {"│", "FloatBorder"},
    {"╯", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╰", "FloatBorder"},
    {"│", "FloatBorder"},
}

-- Show diagnostics in popup window (using the border above)
vim.api.nvim_command(
    "autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({border="
-- {border="
    ..vim.inspect(popup_border)..
    ", focusable=false, show_header=false})"
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false, -- if using pop-up window
    -- virtual_text =  { -- for text displayed in buffer
    --     prefix = "»",
    --     spacing = 0,
    -- },
    signs = false,
    underline = true,
    update_in_insert = false, -- update diagnostics insert mode
    severity_sort = true,
})


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
vim.lsp.handlers.hover, {
    border = popup_border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
vim.lsp.handlers.signature_help, {
    border = popup_border,
})

-- suppress error messages from lang servers
vim.notify = function(msg, log_level, _opts)
    if msg:match "exit code" then
        return
    end
    if log_level == vim.log.levels.ERROR then
        vim.api.nvim_err_writeln(msg)
    else
        vim.api.nvim_echo({ { msg } }, true, {})
    end
end

return on_attach
