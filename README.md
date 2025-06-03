# dbt Fusion Dev Container Template
A development container template for dbt projects that use [the new Fusion engine](https://github.com/dbt-labs/dbt-fusion) with the official dbt VS Code extension.

## What's a dev container?
- A dev container is a Docker container specifically configured to serve as a fully featured, consistent, isolated, and portable development environment
- Defined in `.devcontainer/devcontainer.json` within a project
- Read more about them in [GitHub Docs](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)

## Why should I use dbt-fusion within a container? 
[dbt-fusion](https://github.com/dbt-labs/dbt-fusion) is written in [Rust](https://www.rust-lang.org/), not Python. So Python virtual environments like `venv` don’t apply here. Instead, `dbt-fusion` installs as a standalone app (called a “binary”) directly onto your system. That makes it easy to run, but it also means it could potentially clash with other dbt tools you have installed, especially Python-based `dbt-core` packages. If you want to avoid that, using a dev container is a solid option.

## Requirements
- [Docker Desktop](https://docs.docker.com/desktop/)
- VS Code with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (or [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer)) extension
- A `dbt` project with a proper:
  - `dbt_project.yml` in the workspace/project folder root
  - Proper configs in your local `~/.dbt` directory

## Features
- A clean and isolated environment to run the official dbt VS Code Extension 
  - The extension will download `dbt-fusion` on your behalf
  - Also compatible with Cursor
- Base Python development environment / tools
  - `Python 3.12` and `uv`
  - __Note:__ The `dbt-fusion` engine does NOT need Python to run. These are added to the base image to enable flexibility for being able to easily add other Python-based dev tools or to run arbitrary Python in the dev container.
- Git
- Pre-configured settings for SQL, YAML, and Python

## Usage
For a detailed configuration (and comments about what each is for), check out the example configuration [here](https://github.com/brooklyn-data/dbt-fusion-devcontainer/blob/main/src/dbt-fusion/.devcontainer/devcontainer.json).

1. Add the following to your project's `.devcontainer/devcontainer.json`:
   ```json
   {
     "image": "ghcr.io/brooklyn-data/dbt-fusion-devcontainer/dbt-fusion:latest",
     "remoteUser": "vscode",
     "mounts": [
       "source=${localEnv:HOME}/.dbt,target=/home/vscode/.dbt,type=bind",
       "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind" // mount if git authentication uses SSH
     ],
     "workspaceMount": "source=${localWorkspaceFolder},target=/workspaces/${localWorkspaceFolderBasename},type=bind,consistency=cached",
     "workspaceFolder": "/workspaces/${localWorkspaceFolderBasename}",
     "customizations": {
       "vscode": {
         "settings": {
           "dbt.dbtPath": "/home/vscode/.local/bin/dbt",
           "files.associations": {
             "*.sql": "sql",
             "*.yml": "yaml"
           },
           "[sql]": {
             "editor.defaultFormatter": "dbtLabsInc.dbt",
             "editor.formatOnSave": true
           },
           "[yaml]": {
             "editor.defaultFormatter": "dbtLabsInc.dbt",
             "editor.formatOnSave": true
           },
           "[python]": {
             "editor.defaultFormatter": "charliermarsh.ruff",
             "editor.formatOnSave": true
           },
           "yaml.schemas": {
             "https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/dbt_yml_files-latest.json": [
               "/**/*.yml",
               "!profiles.yml",
               "!dbt_project.yml",
               "!packages.yml",
               "!selectors.yml",
               "!profile_template.yml",
               "!package-lock.yml"
             ],
             "https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/dbt_project-latest.json": [
               "dbt_project.yml"
             ],
             "https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/selectors-latest.json": [
               "selectors.yml"
             ],
             "https://raw.githubusercontent.com/dbt-labs/dbt-jsonschema/main/schemas/latest/packages-latest.json": [
               "packages.yml"
             ]
          }
         },
         "extensions": [
           "ms-python.python",
           "charliermarsh.ruff",
           "ms-python.vscode-pylance",
           "tamasfe.even-better-toml",
           "EditorConfig.EditorConfig",
           "eamodio.gitlens",
           "visualstudioexptteam.vscodeintellicode",
           "dbtlabsinc.dbt",
           "redhat.vscode-yaml"
         ]
       }
     },
     "features": {
       "ghcr.io/devcontainers/features/common-utils:2": {
         "installZsh": true,
         "username": "vscode",
         "upgradePackages": true
       },
       "ghcr.io/devcontainers/features/python:1": {
         "version": "3.12",
         "installTools": true
       }
     }
   }
   ```

   > **Note**: The extensions with this configuration are installed by VS Code when the container starts for ease of setup. To manage the extension installation yourself, remove the `"features"` key from the `devcontainer.json` file.

2. Open your project in VS Code and use the Dev Containers (or Remote Explorer) extension to build and run the container. ([docs](https://code.visualstudio.com/docs/devcontainers/containers))

3. Allow some time for the extensions to install and follow dbt's prompt to install `dbt-fusion`

## dbt Fusion Resources
- [Meet the dbt Fusion Engine... - Jason Ganz](https://docs.getdbt.com/blog/dbt-fusion-engine)
- [Up & Running with dbt Fusion Engine and VS Code - Anders Swanson](https://www.loom.com/share/c6f72d2525b24178a76c6679e43dbc06)
- [Docs: dbt Fusion](https://docs.getdbt.com/docs/fusion/about-fusion)
- [GitHub: dbt-fusion](https://github.com/dbt-labs/dbt-fusion)
- [dbt Fusion Slack Channel](https://getdbt.slack.com/archives/C088YCAB6GH)

## About Brooklyn Data
Brooklyn Data offers full-service capabilities for implementing the modern data stack. Our data experts help you develop impactful data strategies, manage data effectively, and leverage AI to activate your data. Read more at [brooklyndata.co](https://brooklyndata.co). 
