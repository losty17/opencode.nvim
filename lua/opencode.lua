local M = {}

local config = {
  cmd = "opencode",
  width = 80,
  side = "right",
}

local bufnr = nil
local winnr = nil

function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})

  vim.keymap.set("n", "<leader>oc", function()
    M.toggle()
  end, { desc = "Toggle opencode panel", noremap = true, silent = true })
end

function M.toggle()
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    vim.api.nvim_win_close(winnr, true)
    winnr = nil
    return
  end

  local existing_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name:match("opencode") then
        existing_buf = buf
        break
      end
    end
  end

  if existing_buf and vim.api.nvim_buf_is_valid(existing_buf) then
    bufnr = existing_buf
  else
    bufnr = vim.api.nvim_create_buf(false, false)
  end

  local split_cmd = config.side == "left" and "topleft" or "botright"
  vim.cmd(split_cmd .. " " .. config.width .. "vsplit")
  winnr = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(winnr, bufnr)

  if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "terminal" then
    vim.fn.termopen(config.cmd)
  end

  vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "hide")

  vim.api.nvim_win_set_option(winnr, "number", false)
  vim.api.nvim_win_set_option(winnr, "relativenumber", false)
  vim.api.nvim_win_set_option(winnr, "signcolumn", "no")
  vim.api.nvim_win_set_option(winnr, "cursorline", false)

  vim.cmd("startinsert")
end

return M
