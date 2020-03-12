require'nvim-treesitter.configs'.setup {
  highlight = { enable = true, disable = {} },

  indent = { enable = true, disable = { 'nix' } },

  incremental_selection = {
    enable = true,
    keymaps = { init_selection = "gnn", scope_incremental = "grc" }
  },

  refactor = {
    smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>"
      }
    }
  },

  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      }
    },

    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner" },
      swap_previous = { ["<leader>A"] = "@parameter.inner" }
    },

    move = {
      enable = true,
      goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
      goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer"
      },
      goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" }
    },

    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer"
      }
    }
  },

  rainbow = { enable = true, disable = { 'bash' } }
}
