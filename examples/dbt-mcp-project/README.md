# dbt Fusion + MCPs + Claude Code Example

This example demonstrates how to set up a dbt project that integrates **Model Context Protocol (MCP) servers** with **Claude Code** (or other LLMs) within a development container environment.

## Overview

This configuration enables you to:
- Work with dbt Fusion in an isolated dev container environment
- Use Claude Code CLI directly within your dbt project
- Connect to multiple MCP servers (dbt, GitHub, Jira) for enhanced AI capabilities
- Maintain a consistent, reproducible development environment across teams

## What is MCP?

The [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) is an open protocol that standardizes how applications provide context to LLMs. MCP servers expose tools, resources, and prompts that AI assistants can use to interact with external systems.

## Key Files

### `.devcontainer/devcontainer.json`
The dev container configuration that:
- Builds from a custom Dockerfile with Python, Node.js, and Claude Code CLI pre-installed
- Mounts your local `~/.dbt` and `~/.ssh` directories for authentication
- Configures VS Code extensions (dbt, Python, YAML, etc.)
- Sets up editor formatting and YAML schema validation for dbt files
- Installs development features (Python 3.12, zsh, common utilities)

**Key settings:**
- `dbt.dbtPath: "/home/vscode/.local/bin/dbt"` - Points to where dbt-fusion will be installed
- Volume mounts ensure dbt profiles and SSH keys are accessible
- YAML schemas provide validation for dbt project files

### `.devcontainer/Dockerfile`
Custom image that includes:
- **Python 3.12** - Base environment
- **Node.js 20** - Required for Claude Code CLI
- **uv** - Fast Python package installer
- **Claude Code CLI** (`@anthropic-ai/claude-code`) - Installed globally via npm
- **Development tools** - git, curl, ruff, pre-commit, sqlfmt

### `.devcontainer/devcontainer.env`
Environment variables for MCP server configuration:

**GitHub MCP:**
- `GITHUB_PAT` - Personal access token for GitHub API access
- `GITHUB_TOOLSETS` - Comma-separated list of enabled toolsets

**dbt MCP:**
- `DBT_HOST` - dbt Cloud host URL
- `DBT_ACCOUNT_ID`, `DBT_USER_ID`, `DBT_TOKEN` - Authentication credentials
- `DBT_PROD_ENV_ID`, `DBT_DEV_ENV_ID` - Environment IDs
- `DBT_PROJECT_DIR` - Path to your dbt project (e.g., `/workspaces/my-dbt-project`)
- `DBT_PATH` - Path to dbt executable
- Feature flags to enable/disable specific capabilities (CLI, Semantic Layer, Discovery, etc.)

### `.mcp.json`
Defines the MCP servers available to Claude Code:

**dbt-mcp:**
- Runs via `uvx dbt-mcp` (automatically installs and executes)
- Provides tools for interacting with dbt Cloud API, running commands, querying documentation, etc.

**github-mcp:**
- Runs in Docker container for security isolation
- Provides tools for GitHub operations (issues, PRs, repos)

**jira-mcp:**
- Runs via remote connection to Atlassian's MCP server
- Provides tools for Jira project management

## Setup Instructions

### 1. Prerequisites
- [Docker Desktop](https://docs.docker.com/desktop/) installed and running
- VS Code with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- Proper [project files](https://docs.getdbt.com/docs/install-dbt-extension) configured

### 2. Configure Environment Variables

Copy `.devcontainer/devcontainer.env` and fill in your credentials:

```bash
# GitHub MCP
GITHUB_PAT=ghp_your_token_here
GITHUB_TOOLSETS=issues,pull-requests

# dbt MCP
DBT_HOST=cloud.getdbt.com
DBT_ACCOUNT_ID=12345
DBT_PROD_ENV_ID=67890
DBT_DEV_ENV_ID=67891
DBT_USER_ID=98765
DBT_TOKEN=your_dbt_token
DBT_PROJECT_DIR=/workspaces/your-repo-name
DBT_PATH=/home/vscode/.local/bin/dbt
...
```

**Note:** Update `DBT_PROJECT_DIR` to match your repository name (the `${localWorkspaceFolderBasename}` value).

### 3. Open in Dev Container

1. Open your dbt project folder in VS Code
2. Press `Cmd/Ctrl + Shift + P` and select **"Dev Containers: Reopen in Container"**
3. Wait for the container to build and extensions to install
4. When prompted by the dbt extension, allow it to install dbt-fusion

### 4. Verify Setup

Open a terminal in the container and verify installations:

```bash
# Check Claude Code CLI
claude --version

# Check dbt-fusion (after extension installs it)
dbt --version

# Check Python environment
python --version
uv --version
```

### 5. Use Claude Code with MCP

Start Claude Code in your project:

```bash
claude
```

Verify MCPs:

```bash
/mcp
```

Claude will now have access to the MCP servers defined in `.mcp.json`. You can ask Claude to:

**With dbt MCP:**
- "Show me the lineage for model `stg_customers`"
- "Run the test suite for the staging models"
- "What's the documentation for the `orders` source?"
- "What caused the error in the production run #412345?"

**With GitHub MCP:**
- "Create an issue for the bug in the order calculation"
- "Show me open PRs for this repository"
- "What were the recent commits to main?"

**With Jira MCP:**
- "Show me my assigned tickets"
- "Update ticket DATA-123 with the latest progress"

## Additional Notes
- This is just a template/example of the relevant files and configs needed to get up-and-running
