
| Keybind | Function | What it does |
|---|---|---|
| `K` | `vim.lsp.buf.hover` | Info bubble — docs/type info for whatever's under the cursor |
| `gd` | `vim.lsp.buf.definition` | Jump to where the symbol is defined |
| `gD` | `vim.lsp.buf.declaration` | Jump to declaration (distinct from definition — mostly matters in C/C++ header vs. source |
| `gi` | `vim.lsp.buf.implementation` | Jump to implementation  |
| `go` | `vim.lsp.buf.type_definition` | Jump to the type's definition, not the variable's |
| `gr` | `vim.lsp.buf.references` | List every place this symbol is used across the project |
| `gs` | `vim.lsp.buf.signature_help` | Shows a function's parameter signature while you're typing a call |
| `gl` | `vim.diagnostic.open_float` | Show the full diagnostic (error/warning) message under the cursor |
| `<F2>` | `vim.lsp.buf.rename` | Rename the symbol everywhere it's used |
| `<F3>` (normal + visual) | `vim.lsp.buf.format({ async = true })` | Format the buffer/selection using the LSP's formatter |
| `<F4>` | `vim.lsp.buf.code_action` | Show available quick-fixes/refactors (e.g. "add missing import", "extract variable") |
