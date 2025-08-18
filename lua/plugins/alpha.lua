
-- lua/plugins/alpha.lua
return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },
}
