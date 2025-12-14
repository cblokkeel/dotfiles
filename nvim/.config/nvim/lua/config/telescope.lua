local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local live_multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    local finder = finders.new_async_job {
        command_generator = function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            local pieces = vim.split(prompt, "  ")
            local args = { "rg" }
            if pieces[1] then
                table.insert(args, "-e")
                table.insert(args, pieces[1])
            end

            if pieces[2] then
                table.insert(args, "-g")
                table.insert(args, pieces[2])
            end

            ---@diagnostic disable-next-line: deprecated
            return vim.tbl_flatten {
                args,
                { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--glob", "!node_modules/" },
            }
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    }

    pickers.new(opts, {
        debounce = 100,
        prompt_title = "Multi Grep",
        finder = finder,
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty(),
    }):find()
end

local entry_display = require("telescope.pickers.entry_display")

-- Custom picker: show only unsaved buffers
local function unsaved_buffers_picker()
    local results = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
            and vim.api.nvim_buf_get_option(buf, "modified")
        then
            table.insert(results, {
                buf = buf,
                name = vim.api.nvim_buf_get_name(buf),
            })
        end
    end

    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = 4 },
            { remaining = true },
        },
    })

    local function make_display(entry)
        return displayer({ entry.buf, entry.name })
    end

    pickers
        .new({}, {
            prompt_title = "Unsaved Buffers",
            finder = finders.new_table({
                results = results,
                entry_maker = function(entry)
                    return {
                        value = entry.buf,
                        ordinal = entry.name,
                        display = make_display,
                        buf = entry.buf,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_, map)
                -- Enter to switch to buffer
                actions.select_default:replace(function(prompt_bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.api.nvim_set_current_buf(selection.buf)
                end)
                return true
            end,
        })
        :find()
end

vim.keymap.set("n", "<leader>fub", unsaved_buffers_picker, { desc = "Telescope Unsaved Buffers" })
vim.keymap.set("n", "<leader>fg", live_multigrep)
