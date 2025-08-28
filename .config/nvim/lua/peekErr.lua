-- lua/float_diagnostics.lua
local M = {}

-- Default configuration
local config = {
	toggle_key = "<leader>p",
	jump_key = "gl",
	quit_key = "q",
	width_ratio = 0.6,
	height_ratio = 0.3,
	highlights = {
		error = "red",
		warn = "yellow",
		info = "blue",
		hint = "gray",
	},
}

-- Internal state
local win_id = nil
local bufh = nil
local source_buf = nil

-- Function to setup user configuration
function M.setup(user_config)
	if user_config then
		for k, v in pairs(user_config) do
			config[k] = v
		end
	end

	-- Define highlight groups
	vim.api.nvim_set_hl(0, "DiagFloatError", { fg = config.highlights.error })
	vim.api.nvim_set_hl(0, "DiagFloatWarn", { fg = config.highlights.warn })
	vim.api.nvim_set_hl(0, "DiagFloatInfo", { fg = config.highlights.info })
	vim.api.nvim_set_hl(0, "DiagFloatHint", { fg = config.highlights.hint })

	-- Set global toggle key
	vim.keymap.set("n", config.toggle_key, M.toggle, { noremap = true, silent = true })
end

-- Function to open/toggle the floating window
function M.toggle()
	if win_id and vim.api.nvim_win_is_valid(win_id) then
		vim.api.nvim_win_close(win_id, true)
		win_id, bufh = nil, nil
		return
	end

	bufh = vim.api.nvim_create_buf(false, true)
	source_buf = vim.api.nvim_get_current_buf()

	local diags = vim.diagnostic.get(source_buf)
	local lines, highlights = {}, {}

	for _, d in ipairs(diags) do
		local msg = d.message:gsub("\n", " ")
		local line = string.format("%d:%d  %s", d.lnum + 1, d.col + 1, msg)
		table.insert(lines, line)

		local hl_group
		if d.severity == vim.diagnostic.severity.ERROR then
			hl_group = "DiagFloatError"
		elseif d.severity == vim.diagnostic.severity.WARN then
			hl_group = "DiagFloatWarn"
		elseif d.severity == vim.diagnostic.severity.INFO then
			hl_group = "DiagFloatInfo"
		else
			hl_group = "DiagFloatHint"
		end

		table.insert(highlights, { #lines - 1, 0, #tostring(d.lnum + 1) + #tostring(d.col + 1) + 1, hl_group })
	end

	if #lines == 0 then
		table.insert(lines, "No diagnostics")
	end

	vim.api.nvim_buf_set_lines(bufh, 0, -1, false, lines)
	for _, hl in ipairs(highlights) do
		local lnum, start_col, end_col, group = unpack(hl)
		vim.api.nvim_buf_add_highlight(bufh, -1, group, lnum, start_col, end_col)
	end

	-- Quit keymap
	vim.keymap.set(
		"n",
		config.quit_key,
		"<cmd>bd!<CR>",
		{ buffer = bufh, nowait = true, noremap = true, silent = true }
	)

	-- Jump keymap
	vim.keymap.set("n", config.jump_key, function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_buf_get_lines(bufh, cursor[1] - 1, cursor[1], false)[1]
		local l, c = line:match("^(%d+):(%d+)")
		if l and c then
			vim.api.nvim_win_close(win_id, true)
			win_id, bufh = nil, nil
			vim.api.nvim_set_current_buf(source_buf)
			vim.api.nvim_win_set_cursor(0, { tonumber(l), tonumber(c) - 1 })
		end
	end, { buffer = bufh, noremap = true, silent = true })

	-- Floating window size
	local width = math.floor(vim.o.columns * config.width_ratio)
	local height = math.min(#lines + 2, math.floor(vim.o.lines * config.height_ratio))
	local row = math.floor((vim.o.lines - height) / 2 - 1)
	local col = math.floor((vim.o.columns - width) / 2)

	win_id = vim.api.nvim_open_win(bufh, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
end

return M
