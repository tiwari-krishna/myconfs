-- Oil Configuration
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Mini Stuff
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.jump").setup({
	silent = true,
	delay = {
		highlight = 50,
		idle_stop = 100,
	},
})
require("mini.surround").setup({
	silent = true,
	search_method = "cover_or_nearest",
})

-- Live Preview
vim.keymap.set("n", "<leader>lp", "<CMD>LivePreview start<CR>", { desc = "Live Preview Start" })
vim.keymap.set("n", "<leader>ls", "<CMD>LivePreview close<CR>", { desc = "Live Preview Close" })

--Undotree
vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle)

------- Formatter (Coform) -------
require("conform").setup({
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 1000,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		markdown = { "prettier" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		python = { "black" },
		json = { "prettier" },
		yaml = { "prettier" },
	},
	formatters = {
		clang_format = {
			args = { "-style={BasedOnStyle: llvm, IndentWidth: 4, UseTab: Never}" },
		},
	},
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Code Format" })
