local M = {
    namespace   = vim.api.nvim_create_namespace('playground'),
}

function M.init(width, height)
    M.buffer      = vim.fn.bufnr('%')
    M.width       = width
    M.height      = height
    M.sleep       = 4

    M.pixels      = {}
    for y = 1,M.height,1 do
        M.pixels[y] = {}
        for x = 1,M.width,1 do
            M.pixels[y][x] = M.set_pixel(" ", "Normal")
        end
    end
end

function M.set_pixel(character, highlight_group)
    return {character, highlight_group}
end

function M.display()
    local first_visible = vim.fn.line('w0') - 1
    local win_height = vim.api.nvim_win_get_height(0)
    local win_width  = vim.api.nvim_win_get_width(0)

    local first_h = math.floor((win_height/2) + first_visible - (M.height/2))
    local first_w = math.floor((win_width/2) - (M.width/2))

    for i = 1,M.height,1 do
        vim.api.nvim_buf_set_extmark(M.buffer, M.namespace, first_h + i-1, 0, {
            id = i,
            virt_text = M.pixels[i],
            virt_text_win_col = first_w,
        })
    end
end

function M.clear()
    for i = 0,M.height,1 do
        vim.api.nvim_buf_del_extmark(M.buffer, M.namespace, i+1)
    end
end

function M.run()
    M.init(50, 25)
    local row    = 1
    local column = 1
    M.timer = vim.loop.new_timer()
    M.timer:start(0, M.sleep, vim.schedule_wrap(function()

        if (column % M.width == 0) then
            row = row+1
            column = 1
        end

        if (row == M.height) then
            M.stop()
            return
        end

        M.pixels[row][column] = M.set_pixel(string.char(math.random(65, 122)), "PmenuSel")

        column = column+1
        -- M.clear()
        M.display()
    end))
end

function M.stop()
    if M.timer ~= nil then
        M.timer:stop()
        M.timer:close()
        M.timer = nil
        vim.cmd("sleep 20m")
        M.clear()
    end
end

return M
