

--Neozoom

vim.keymap.set('n','<C-ESC>', function ()
	vim.cmd('NeoZoomToggle') 
end, { silent = true, nowait = true })

