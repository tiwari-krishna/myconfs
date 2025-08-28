vim.g.mapleader = " "
vim.g.maplocalleader = " "
local opts = { noremap = true, silent = true }
local kmp = vim.api.nvim_set_keymap

-- Normal Mode
kmp("n", "<C-h>", "<C-w>h", opts)
kmp("n", "<C-j>", "<C-w>j", opts)
kmp("n", "<C-k>", "<C-w>k", opts)
kmp("n", "<C-l>", "<C-w>l", opts)

kmp("n", "<leader>vh", ":split<CR>", opts)
kmp("n", "<leader>vv", ":vsplit<CR>", opts)
kmp("n", "<C-c>", ":close<CR>", opts)

kmp("n", "<leader>j", ":bnext<CR>", opts)
kmp("n", "<leader>k", ":bprevious<CR>", opts)

kmp("n", "<leader>qq", ":bdelete<CR>", opts)

kmp("n", "<C-Up>", ":resize +2<CR>", opts)
kmp("n", "<C-Down>", ":resize -2<CR>", opts)
kmp("n", "<C-Left>", ":vertical resize +2<CR>", opts)
kmp("n", "<C-Right>", ":vertical resize -2<CR>", opts)

kmp("n", "<leader>cd", ":cd %:p:h<CR>", opts)
kmp("n", "<leader>ss", ":w<CR>", opts)

-- compiler command
kmp("n", "<leader>cc", [[:w! | lua vim.cmd('!compiler "%:p"')<CR>]], opts)

--Insert Mode
kmp("i", "<C-b>", "<ESC>^i", opts)
kmp("i", "<C-e>", "<End>", opts)

-- Visual block Mode
kmp("v", "J", ":m '>+1<CR>gv=gv", opts)
kmp("v", "K", ":m '<-2<CR>gv=gv", opts)

--visual character mode copy to system clipboard
kmp("x", "<leader>p", [["_dP]], opts)

kmp("n", "J", "mzJ`z", opts)
kmp("n", ",", "<C-d>zz", opts)
kmp("n", "<", "<C-u>zz", opts)

kmp("n", "n", "nzzzv", opts)
kmp("n", "N", "Nzzzv", opts)
kmp("n", "=ap", "ma=ap'a", opts)

vim.keymap.set({ "n", "v" }, "<C-y>", [["+y]])

vim.keymap.set({ "n", "v" }, "<C-p>", [["+p]])

vim.keymap.set("n", "<C-Y>", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

kmp("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
kmp("n", "<leader>xx", "<cmd>!chmod +x %<CR>", opts)

-- kmp("n", "<leader>z", "<cmd>:wa<CR>", opts)
kmp("n", "<leader>Z", "<cmd>:wqa<CR>", opts)

-- Relace in visual mode without changing register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Save and close everything else than the current buffer
local function save_and_close_other_buffers()
	local current_buf = vim.api.nvim_get_current_buf()

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			if vim.api.nvim_buf_get_option(buf, "modified") and vim.api.nvim_buf_get_option(buf, "modifiable") then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd("write")
				end)
			end
			vim.api.nvim_buf_delete(buf, { force = false })
		end
	end
end

vim.keymap.set("n", "<leader>qQ", save_and_close_other_buffers)
