return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    formatters = {
      ["clang-format"] = {
        prepend_args = { "-style={IndentWidth: 4, BasedOnStyle: LLVM}" },
      },
    },
    -- This is the "Autoformat on Save" logic
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback", -- Use LSP if no dedicated formatter is found
    },
  },
}
