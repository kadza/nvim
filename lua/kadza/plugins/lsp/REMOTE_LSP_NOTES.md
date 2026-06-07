# Remote LSP Setup Notes (devpod / OrbStack container)

## Final working setup

- **pylsp** via `docker exec` — ruff for linting, completions, hover, go-to-definition
- **pyrefly** via `docker exec` — type checking (Meta's Rust-based checker, no Node.js required)
- LSP config lives in `.nvim.lua` in the project root (not global nvim config)
- `opt.exrc = true` in global Neovim options enables per-project `.nvim.lua`

## Container details

- Name: `claude_api_course`
- Managed by: devpod + OrbStack
- Workspace mount: `/workspaces/claude-api-course`
- Python: `/usr/local/bin/python3` (3.12)
- User packages: `/home/vscode/.local/lib/python3.12/site-packages/`

## Connection method: docker exec

Neovim's LSP client communicates over stdin/stdout. Setting `cmd` to `docker exec`
pipes that stdin/stdout into the container process — Neovim thinks it's talking to
a local binary.

```lua
cmd = { "docker", "exec", "-i", "-u", "vscode", "-e", "HOME=/home/vscode",
        "claude_api_course", "/path/to/lsp-binary" }
```

- `-i` — keeps stdin open for the JSON-RPC pipe
- `-u vscode` — run as the vscode user
- `-e HOME=/home/vscode` — required so Python finds user-installed packages;
  `docker exec` does not source the shell profile

## Path mismatch problem

Neovim (on Mac) sends file URIs with the host path:
  `file:///Users/lkujawia/dev/private/claude-api-course/...`

The container has files at:
  `/workspaces/claude-api-course/...`

### Solution: dynamic symlink in setup.sh

Create the symlink inside the container so the host path resolves correctly.
`LOCAL_WORKSPACE_FOLDER` must be injected via `containerEnv` in `devcontainer.json`
— it is NOT available automatically. `CONTAINER_WORKSPACE_FOLDER` is also not
injected automatically; use `$PWD` instead since `postCreateCommand` runs from
the workspace folder.

```bash
if [ -n "$LOCAL_WORKSPACE_FOLDER" ]; then
  HOST_PARENT=$(dirname "$LOCAL_WORKSPACE_FOLDER")
  sudo mkdir -p "$HOST_PARENT"
  if [ ! -e "$LOCAL_WORKSPACE_FOLDER" ]; then
    sudo ln -s "$PWD" "$LOCAL_WORKSPACE_FOLDER"
  fi
fi
```

## devcontainer.json

```json
{
  "name": "claude_api_course",
  "image": "mcr.microsoft.com/devcontainers/python:3.12",
  "containerEnv": {
    "LOCAL_WORKSPACE_FOLDER": "${localWorkspaceFolder}"
  },
  "postCreateCommand": "bash .devcontainer/setup.sh",
  "runArgs": ["--name", "claude_api_course"]
}
```

No Node.js feature needed — pyrefly is a Rust binary.

## devcontainer setup.sh

```bash
#!/bin/bash

set -e

pip install --upgrade pip
pip install anthropic python-dotenv
pip install python-lsp-server python-lsp-ruff pyrefly

if [ -n "$LOCAL_WORKSPACE_FOLDER" ]; then
  HOST_PARENT=$(dirname "$LOCAL_WORKSPACE_FOLDER")
  sudo mkdir -p "$HOST_PARENT"
  if [ ! -e "$LOCAL_WORKSPACE_FOLDER" ]; then
    sudo ln -s "$PWD" "$LOCAL_WORKSPACE_FOLDER"
  fi
fi
```

## pyrefly configuration

pyrefly defaults to the `basic` preset which does not report type errors.
Run `pyrefly init` once in the project root to generate `pyrefly.toml`:

```bash
docker exec -u vscode -e HOME=/home/vscode -w /workspaces/claude-api-course \
  claude_api_course /home/vscode/.local/bin/pyrefly init
```

Commit `pyrefly.toml` to the repo so it persists across container rebuilds.

## Project .nvim.lua

Place in the project root. Neovim prompts to trust it on first open.

```lua
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.pylsp.setup({
  capabilities = capabilities,
  cmd = { "docker", "exec", "-i", "-u", "vscode", "-e", "HOME=/home/vscode",
          "claude_api_course", "/home/vscode/.local/bin/pylsp" },
  root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml", "setup.py"),
  settings = {
    pylsp = {
      plugins = {
        ruff = { enabled = true },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        pylsp_mypy = { enabled = false },
        autopep8 = { enabled = false },
      },
    },
  },
})

local configs = require("lspconfig.configs")
if not configs.pyrefly then
  configs.pyrefly = {
    default_config = {
      cmd = { "docker", "exec", "-i", "-u", "vscode", "-e", "HOME=/home/vscode",
              "claude_api_course", "/home/vscode/.local/bin/pyrefly", "lsp" },
      filetypes = { "python" },
      root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml", "setup.py"),
      single_file_support = true,
    },
  }
end

lspconfig.pyrefly.setup({ capabilities = capabilities })
```

## What was abandoned and why

### pyright
Crashes exactly 2 seconds after completing initial analysis, every time,
regardless of connection method, Node.js version, path setup, or config.
Exit code 1, no stderr. Root cause unknown.

### mypy (pylsp-mypy)
INTERNAL ERROR with mypy 2.1.0 in live_mode. Bug in mypy itself.

### pylint (nvim-lint)
Ran locally on the host, couldn't resolve container-installed packages,
produced false import errors for everything.
