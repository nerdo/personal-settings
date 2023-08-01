local present, notify = pcall(require, "notify")

if not present then
	return
end

notify.setup({})
vim.notify = notify
