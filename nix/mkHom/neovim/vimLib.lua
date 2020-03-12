command = vim.api.nvim_command
nvim_set_keymap = vim.api.nvim_set_keymap

function nmap(kimap, akcyn)
  nvim_set_keymap('n', kimap, akcyn, { noremap = false, silent = true })
end

function nnoremap(kimap, akcyn)
  nvim_set_keymap('n', kimap, akcyn, { noremap = true, silent = true })
end

function inoremap(kimap, akcyn)
  nvim_set_keymap('i', kimap, akcyn, { noremap = true, silent = true })
end

function inoremapExpr(kimap, akcyn)
  nvim_set_keymap('i', kimap, akcyn,
    { noremap = true, silent = true, expr = true })
end

function imap(kimap, akcyn)
  nvim_set_keymap('i', kimap, akcyn, { noremap = false, silent = true })
end

function noremap(kimap, akcyn)
  nvim_set_keymap('n', kimap, akcyn, { noremap = true, silent = true })
  nvim_set_keymap('v', kimap, akcyn, { noremap = true, silent = true })
  nvim_set_keymap('o', kimap, akcyn, { noremap = true, silent = true })
end

function noremap(kimap, akcyn)
  nvim_set_keymap('n', kimap, akcyn, { noremap = true, silent = true })
  nvim_set_keymap('v', kimap, akcyn, { noremap = true, silent = true })
  nvim_set_keymap('o', kimap, akcyn, { noremap = true, silent = true })
end

function noremapEks(kimap, akcyn)
  nvim_set_keymap('!', kimap, akcyn, { noremap = true, silent = true })
end

function nnoremapBufferExpr(kimap, akcyn)
  vim.api.nvim_buf_set_keymap(0, 'n', kimap, akcyn,
    { noremap = true, silent = true, expr = true })
end

function tmap(kimap, akcyn)
  nvim_set_keymap('t', kimap, akcyn, { noremap = false, silent = true })
end

function tnoremap(kimap, akcyn)
  nvim_set_keymap('t', kimap, akcyn, { noremap = true, silent = true })
end
