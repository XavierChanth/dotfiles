vim.keymap.set("n", "q", ":q<cr>", { buffer = 0})
vim.keymap.set("n", "<C-x>", function()
          vim.cmd([[
            let curqfidx = line('.') - 1
            let qfall = getqflist()
            call remove(qfall, curqfidx)
            call setqflist(qfall, 'r')
            :copen
          ]])
end, {})

