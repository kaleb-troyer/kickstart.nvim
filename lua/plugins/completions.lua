
return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",      -- LSP completions
      "hrsh7th/cmp-buffer",        -- buffer words
      "hrsh7th/cmp-path",          -- filesystem paths
      "saadparwaiz1/cmp_luasnip",  -- snippets
      "L3MON4D3/LuaSnip",          -- snippet engine
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
        --   ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        --   ["<C-f>"] = cmp.mapping.scroll_docs(4),
        --   ["<C-Space>"] = cmp.mapping.complete(),
        --   ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()           -- move to next completion item
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()         -- expand snippet or jump
          else
            fallback()                        -- fallback to normal Tab
          end
        end, { "i", "s" }),                  -- works in insert & select modes

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()           -- move to previous completion item
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)                 -- jump backward in snippet
          else
            fallback()
          end
        end, { "i", "s" }),

        -- ["<CR>"] = cmp.mapping.confirm({ select = true }), 
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),

        window = {
            completion = nil,
        },

        completion = {
            autocomplete = false,
        },

        experimental = {
            ghost_text = true,
        },
      })
    end,
  },
  vim.api.nvim_set_keymap(
    'i',                   -- insert mode
    '<C-Space>',           -- key combination
    '<Cmd>lua require("cmp").complete()<CR>', -- call cmp.complete()
    { noremap = true, silent = true }
  )
}
