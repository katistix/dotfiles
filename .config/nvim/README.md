# nvim

Default Neovim config: a single `init.lua`, lazy.nvim and Telescope, with
first-class support for Prolog (PLF course), C/C++ and vanilla web development
(HTML5, CSS and JavaScript).

## Requirements

- Neovim 0.12+
- `git`, `make` and a C compiler (Telescope's fzf-native build)
- `fzf` and `ripgrep` (optional, but recommended)
- Node.js and npm (web language servers, Emmet, Prettier)
- SWI-Prolog: `brew install swi-prolog`
- Prolog language server (optional, but recommended):

  ```sh
  swipl pack install lsp_server
  ```

  When the pack is missing, Prolog files still get syntax highlighting,
  indentation and the run/REPL keymaps below; the LSP features are simply
  skipped.

## Prolog

- `.prolog` and `.plt` files are always treated as Prolog. `.pl` is shared with
  Perl, so Neovim detects it from the file contents; use `:set ft=prolog` for an
  empty new `.pl` file.
- Built-in Vim syntax, indentation and ftplugin are used, with 4-space soft tabs.
- The [SWI-Prolog LSP](https://github.com/jamesnvc/lsp_server) provides
  diagnostics, completion, hover documentation, go-to-definition/references,
  renaming and formatting.
- Leader is `<Space>`.

| Key | Action |
| --- | --- |
| `<leader>rr` | save and consult the current file in a SWI-Prolog REPL |
| `<leader>rs` | start a SWI-Prolog REPL in the project directory |
| `<leader>rq` | prompt for a goal and run it against the current file |
| `<leader>cf` | format the buffer with the Prolog LSP |
| `gd` / `gr` / `gI` | definition / references / implementation |
| `K` | hover documentation |
| `<leader>rn` / `<leader>ca` | rename / code action |
| `<leader>cd` | line diagnostics |
| `]d` / `[d` | next / previous diagnostic |

Query results are printed as a list of solutions, e.g. `bunic(ana, X)` gives
`[[X=maria]]`; an empty list means the query failed.

## HTML / CSS / JavaScript

Vanilla HTML5 sites: `.html`/`.htm` are treated as HTML5, `.css` as CSS, and
`.js`/`.mjs`/`.cjs` (plus TypeScript and JSX/TSX) get JavaScript support.
Neovim's built-in syntax highlighting, indentation and ftplugins are used.

Install the language servers and tools once:

```sh
npm install -g vscode-langservers-extracted typescript@5 \
  typescript-language-server @olrtg/emmet-language-server prettier
```

`typescript@5` is deliberate: `typescript-language-server` does not support the
TypeScript 7 (native) package layout yet. The config points the server at the
global `tsserver`; a project with its own `typescript` in `node_modules` takes
precedence.

| Tool | Filetypes | Features |
| --- | --- | --- |
| `vscode-html-language-server` | html | completion, hover, validation, formatting |
| `vscode-css-language-server` | css, scss, less | completion, hover, validation |
| `vscode-json-language-server` | json, jsonc | completion, validation |
| `typescript-language-server` | js, jsx, ts, tsx | completion, diagnostics, go-to-definition, rename |
| `emmet-language-server` | html, css, scss, jsx, tsx | Emmet abbreviation expansion |
| `prettier` (via conform.nvim) | html, css, scss, less, js, ts, json | formatting |

Emmet: type an abbreviation such as `ul>li*3` and accept the completion popup
(`<CR>` or `<Tab>`).

| Key | Action |
| --- | --- |
| `<leader>cf` | format the buffer with Prettier |
| `<leader>co` | save and open the current page in the default browser |
| `<leader>cs` | serve the current file's directory at `http://localhost:8000` |

Use `<leader>cs` (not `<leader>co`) when the page uses ES modules, `fetch()` or
anything else that browsers block on `file://` URLs.
