-- Don't show any numbers inside terminals
vim.cmd [[ autocmd TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't show status line on certain windows
vim.cmd [[ autocmd BufEnter,BufWinEnter,FileType,WinEnter * lua require("core.utils").hide_statusline() ]]

-- Open a file from its last left off position
vim.cmd [[ autocmd BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

-- Trim white spaces on save
vim.cmd [[ autocmd BufWritePre * :%s/\s\+$//e ]]

-- Comment with slashes in c/c++
vim.cmd [[ autocmd BufEnter *.cpp,*.hpp,*.c,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s") ]]

-- Highlight yanked region
vim.cmd [[ autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="FloatBorder", timeout=250} ]]

