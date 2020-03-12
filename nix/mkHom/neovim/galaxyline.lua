local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista', 'dbui' }

local colors = {
  bg = '#202328',
  fg = '#bbc2cf',
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67'
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
  return false
end

gls.left[1] = { RainbowRed = { provider = function() return '▊ ' end } }

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors.magenta,
        i = colors.green,
        v = colors.blue,
        [''] = colors.blue,
        V = colors.blue,
        c = colors.red,
        no = colors.magenta,
        s = colors.orange,
        S = colors.orange,
        [''] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!'] = colors.red,
        t = colors.red
      }
      vim.api
        .nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()])
      return '  '
    end
  }
}

gls.left[3] = {
  FileSize = { provider = 'FileSize', condition = buffer_not_empty }
}

gls.left[4] = {
  FileIcon = { provider = 'FileIcon', condition = buffer_not_empty }
}

gls.left[5] = {
  FileName = { provider = { 'FileName' }, condition = buffer_not_empty }
}

gls.left[6] = { LineInfo = { provider = 'LineColumn', separator = ' ' } }

gls.left[7] = { PerCent = { provider = 'LinePercent', separator = ' ' } }

gls.left[8] = {
  DiagnosticError = { provider = 'DiagnosticError', icon = '  ' }
}
gls.left[9] =
  { DiagnosticWarn = { provider = 'DiagnosticWarn', icon = '  ' } }

gls.left[10] = {
  DiagnosticHint = { provider = 'DiagnosticHint', icon = '  ' }
}

gls.left[11] = {
  DiagnosticInfo = { provider = 'DiagnosticInfo', icon = '  ' }
}

gls.right[1] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = require('galaxyline.provider_vcs').check_git_workspace,
    separator = ' '

  }
}

gls.right[2] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = require('galaxyline.provider_vcs').check_git_workspace
  }
}

local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then return true end
  return false
end

gls.right[3] = {
  DiffAdd = { provider = 'DiffAdd', condition = checkwidth, icon = '  ' }
}
gls.right[4] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' 柳'

  }
}
gls.right[5] = {
  DiffRemove = { provider = 'DiffRemove', condition = checkwidth, icon = '  ' }
}

gls.right[6] = { RainbowBlue = { provider = function() return ' ▊' end } }

gls.right[7] = {
  LspStatus = {
    provider = function()
      local function runit()
        if #vim.lsp.buf_get_clients() > 0 then
          return lsp_status.status()
        else
          return 'NoLSPServer'
        end
      end
      if niks.saizAtList.med then
        runit()
      else
        return 'Disabled'
      end
    end
  }
}

gls.short_line_left[1] = {
  BufferType = { provider = 'FileTypeName', separator = ' ' }
}

gls.short_line_left[2] = {
  SFileName = {
    provider = function()
      local fileinfo = require('galaxyline.provider_fileinfo')
      local fname = fileinfo.get_current_file_name()
      for _, v in ipairs(gl.short_line_list) do
        if v == vim.bo.filetype then return '' end
      end
      return fname
    end,
    condition = buffer_not_empty

  }
}

gls.short_line_right[1] = { BufferIcon = { provider = 'BufferIcon' } }
