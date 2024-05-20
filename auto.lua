buffer_number = 20 
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("evaluate", { clear = true }),
	pattern = "source.lua",
	callback = function()
		vim.api.nvim_buf_set_lines(buffer_number, 0, -1, false, {""})
		vim.fn.jobstart({"luac", "-l", "source.lua"}, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				if data then
					vim.api.nvim_buf_set_lines(buffer_number, -1, -1, false, data)
				end
			end,
			on_stderr = function(_, data) 
				if data then
					vim.api.nvim_buf_set_lines(buffer_number, -1, -1, false, data)
					print(data)
				end
			end,
		})
	end,
})
