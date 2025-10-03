return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", function()
        require("snacks").picker.files({
          exclude={
            "tmp",
            "bin",
            "vendor",
            ".devenv",
            ".direnv"
          }
        })
      end, desc = "Find Files (Root Dir)" },
    },
    opts = {
    }
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          cmd = {'bundle', 'exec',  'ruby-lsp' },
        },
        rubocop = {
          cmd = {'bundle', 'exec',  'rubocop' },
        },
      }
    }
  }
}
