require("autoclose").setup({
  keys = {
    ["<"] = {
      escape = true,
      close = true,
      pair = "<>"
    }
  },
  options = {
    auto_indent = true
  }
})
