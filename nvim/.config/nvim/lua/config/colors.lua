local hl = vim.api.nvim_set_hl

hl(0, 'LineNrAbove', { fg = '#757575', bold = true })
hl(0, 'LineNr', { fg = '#cfcfcf', bold = true })
hl(0, 'LineNrBelow', { fg = '#757575', bold = true })

hl(0, "MiniStatuslineModeNormal", {
    fg = "#000000",
    bg = "#fab387",
    bold = true,
})

hl(0, "MiniStatuslineModeInsert", {
    fg = "#000000",
    bg = "#a6e3a1",
    bold = true,
})

hl(0, "MiniStatuslineModeCommand", {
    fg = "#000000",
    bg = "#b4befe",
    bold = true
})

hl(0, "MiniStatuslineFilename", {
    fg = "#ffffff",
    bg = "NONE",
})
