local M = {}

local config = {
  cmd = "opencode",
  width = 80,
  height = 20,
  side = "right",
}

local bufnr = nil
local winnr = nil
local prev_winnr = nil

function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})

  vim.keymap.set("n", "<leader>oc", function()
    M.toggle()
  end, { desc = "Toggle opencode panel", noremap = true, silent = true })

  vim.keymap.set({ "n", "t" }, "<C-o>", function()
    M.focus()
  end, { desc = "Switch focus to/from opencode panel", noremap = true, silent = true })
end

function M.toggle()
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    if #vim.api.nvim_list_wins() == 1 then
      vim.api.nvim_create_buf(false, true)
    end
    vim.api.nvim_win_close(winnr, true)
    winnr = nil
    return
  end

  M.open()
end

function M.open()
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

  local split_cmd
  local split_type
  local size

  if config.side == "left" then
    split_cmd = "topleft"
    split_type = "vsplit"
    size = config.width
  elseif config.side == "top" then
    split_cmd = "topleft"
    split_type = "split"
    size = config.height
  elseif config.side == "bottom" then
    split_cmd = "botright"
    split_type = "split"
    size = config.height
  else
    split_cmd = "botright"
    split_type = "vsplit"
    size = config.width
  end

  vim.cmd(split_cmd .. " " .. size .. split_type)
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

function M.focus()
  local current_win = vim.api.nvim_get_current_win()

  if winnr and vim.api.nvim_win_is_valid(winnr) and current_win == winnr then
    if prev_winnr and vim.api.nvim_win_is_valid(prev_winnr) then
      vim.api.nvim_set_current_win(prev_winnr)
    end
    return
  end

  prev_winnr = current_win

  if not winnr or not vim.api.nvim_win_is_valid(winnr) then
    M.open()
    return
  end

  vim.api.nvim_set_current_win(winnr)
  vim.cmd("startinsert")
end

return M
