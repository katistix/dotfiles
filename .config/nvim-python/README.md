# nvim-python

Secondary Neovim config, focused on Python. It is deliberately small: one
`init.lua`, lazy.nvim, and only the plugins needed for completion, LSP,
tree-sitter, formatting, fuzzy finding and a statusline.

Launch it with:

```sh
pynvim          # alias for: NVIM_APPNAME=nvim-python nvim
```

Plugins and state are kept under `~/.local/share/nvim-python` and
`~/.local/state/nvim-python`, so this config does not touch the main one.

## Requirements

- Neovim 0.12+
- `git`, `make`, a C compiler (tree-sitter parsers)
- Python with `ruff` and `basedpyright` on `PATH`:
  `uv tool install ruff basedpyright`
- `fzf` (optional but recommended: `ripgrep`, `fd`)
- `tree-sitter` CLI for parser builds

The LSP servers are enabled only when their executables are found, so the
config still loads if the tools are missing.

## Keymaps

Leader is `<Space>`.

| Key | Action |
| --- | --- |
| `<leader>w` / `<leader>q` | save / quit |
| `<leader>rr` | run current file with the project venv |
| `<leader>cf` | format buffer (ruff) |
| `<leader>rf` | run `ruff format` on the file in a terminal |
| `<leader>ff` / `<leader>fg` | find files / live grep |
| `<leader>fb` / `<leader>fh` | buffers / help |
| `<leader>fd` / `<leader>fs` | diagnostics / symbols |
| `gd`, `gr`, `gI`, `K` | definition, references, implementation, hover |
| `<leader>rn` / `<leader>ca` | rename / code action |
| `<leader>cd` | line diagnostics |
| `]d` / `[d` | next / previous diagnostic |
| `<leader>bp` / `<leader>bn` | previous / next buffer |
