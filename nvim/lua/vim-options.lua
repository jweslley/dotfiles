vim.g.mapleader = " "

-- 2 spaces over tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

-- window splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- scrolling
vim.opt.scrolloff = 10
vim.opt.scrolljump = 3
vim.opt.sidescrolloff = 10
vim.opt.sidescroll = 1

-- show line numbers
vim.wo.number = true

-- show sign column so that text doesn't shift
vim.opt.signcolumn = "yes"

-- folding
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 5
vim.opt.foldlevel = 5

-- clipboard: copy/paste to/from system clipboard
vim.opt.clipboard = 'unnamed'

-- keymaps

vim.keymap.set("n", ";", ":")

-- navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- folding
vim.keymap.set("n", "z", "za")
vim.keymap.set("v", "z", "za")

-- make possible to navigate within lines of wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- escape and clear hlsearch
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>nohlsearch<CR><esc>", { silent = true })

-- quickly get out of insert mode without your fingers having to leave the home row
vim.keymap.set("i", "jj", "<Esc>")

-- quit all, very useful in vimdiff
vim.keymap.set("n", "Q", ":qa!<CR>")

-- jump to tag
vim.keymap.set("n", "tt", "<C-]>")

-- indent lines
vim.keymap.set("n", "<", "<<")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- remember cursor position
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})
