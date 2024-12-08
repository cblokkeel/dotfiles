return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
        local builtin = require('telescope.builtin')

        local action_state = require('telescope.actions.state')
        local actions = require('telescope.actions')

        buffer_searcher = function()
            builtin.buffers {
                sort_mru = true,
                ignore_current_buffer = true,
                show_all_buffers = false,
                attach_mappings = function(prompt_bufnr, map)
                    local refresh_buffer_searcher = function()
                        actions.close(prompt_bufnr)
                        vim.schedule(buffer_searcher)
                    end

                    local delete_buf = function()
                        local selection = action_state.get_selected_entry()
                        vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                        refresh_buffer_searcher()
                    end

                    local delete_multiple_buf = function()
                        local picker = action_state.get_current_picker(prompt_bufnr)
                        local selection = picker:get_multi_selection()
                        for _, entry in ipairs(selection) do
                            vim.api.nvim_buf_delete(entry.bufnr, { force = true })
                        end
                        refresh_buffer_searcher()
                    end

                    map('n', 'dd', delete_buf)
                    map('n', '<C-d>', delete_multiple_buf)
                    map('n', '<C-c>', refresh_buffer_searcher)

                    return true
                end
            }
        end

        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', buffer_searcher, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

	end
}

