-- In terminal mode hit C-] to get to Normal mode
vim.keymap.set("t", "<C-]>", [[<C-\><C-n>]], { noremap = true })

--Open Tmux inside of the current directory
local function openTmuxWin()
	local cwd = vim.fn.expand("%:p:h")
	if cwd == "" then
		print("No file path found")
		return
	end
	local cmd = string.format("tmux new-window -c %q", cwd)
	vim.fn.system(cmd)
	print("Opened tmux window in: " .. cwd)
end

-- Open the currnent file inside of a Browser
local function openInBrowser()
	local filepath = vim.fn.expand("%:p")
	if vim.fn.filereadable(filepath) == 0 then
		print("File not found or not readable.")
		return
	end

	local ext = vim.fn.expand("%:e")
	if ext == "html" then
		local escaped_path = vim.fn.shellescape("file://" .. filepath)
		local open_cmd = "$BROWSER " .. escaped_path
		vim.fn.jobstart(open_cmd, { detach = true })
	else
		print("File not supported")
	end
end

-- Store the terminal buffer globally
local term_bufnr = nil

-- The Actual Function Toggle Term
function ToggleTerm()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if buf == term_bufnr then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	if not (term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr)) then
		vim.cmd("belowright 10split")
		vim.cmd("terminal")
		term_bufnr = vim.api.nvim_get_current_buf()
	else
		vim.cmd("belowright 10split")
		vim.api.nvim_win_set_buf(0, term_bufnr)
	end

	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>ob", openInBrowser, { desc = "Open in browser" })
vim.keymap.set("n", "<leader>to", openTmuxWin, { desc = "Open new tmux window here" })
vim.keymap.set("n", "<leader>tt", ToggleTerm, { desc = "Toggle Term here" })

-- Fzf Lua Configuration
require("fzf-lua").setup({
	winopts = {
		height = 0.8,
		width = 0.8,
		row = 0,
		preview = {
			layout = "flex",
			scrollbar = "float",
		},
	},
	fzf_opts = {
		["--layout"] = "reverse",
	},
})

local fzf = require("fzf-lua")

local function findRepo()
	fzf.files({ cwd = vim.fn.expand("~/repo/") })
end

local function getNotes()
	fzf.files({ cwd = vim.fn.expand("~/Data/TODO/") })
end

local function editNvim()
	fzf.files({ cwd = vim.fn.stdpath("config") })
end

local function findBins()
	fzf.files({ cwd = "~/.local/bin" })
end

local function openConfigs()
	fzf.fzf_exec("fd --max-depth 1 . ~/.config", {
		prompt = "Config> ",
		actions = {
			["default"] = function(selected)
				local path = selected[1]
				local stat = vim.loop.fs_stat(path)
				if stat and stat.type == "directory" then
					vim.cmd("cd " .. path)
					print("Changed directory to " .. path)
				else
					vim.cmd("edit " .. path)
				end
			end,
		},
	})
end

vim.keymap.set("n", "<leader>fe", "<CMD>FzfLua files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fp", findRepo, { desc = "Find Repo Files" })
vim.keymap.set("n", "<leader>fv", editNvim, { desc = "Find Neovim config Files" })
vim.keymap.set("n", "<leader>fn", getNotes, { desc = "Get me to my notes" })
vim.keymap.set("n", "<leader>fg", "<CMD>FzfLua live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<CMD>FzfLua buffers<CR>", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fs", findBins, { desc = "Find Shell scripts" })
vim.keymap.set("n", "<leader>fz", "<CMD>FzfLua builtin<CR>", { desc = "Find Builtin Stuff" })
vim.keymap.set("n", "<leader>fcc", openConfigs, { desc = "Find Builtin Stuff" })
