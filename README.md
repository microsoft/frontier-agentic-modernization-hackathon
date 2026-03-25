# GitHub Copilot Modernization

This repository contains hands-on samples that demonstrate how to use the **GitHub Copilot Modernization** extension in VS Code to assess, upgrade, and deploy legacy applications to Azure.

---

## Samples

| Folder | Language | Application | Target |
|---|---|---|---|
| [`java/`](java/) | Java | [Spring Framework PetClinic](https://github.com/spring-petclinic/spring-framework-petclinic) | Azure Container Apps |
| [`dotnet/`](dotnet/) | .NET | Coming soon | Azure Container Apps |

---

## How it works

Each sample follows the same workflow:

1. **Clone** the legacy application source code.
2. **Assess** the codebase with the GitHub Copilot Modernization extension — it identifies outdated dependencies, migration opportunities, and code patterns to simplify.
3. **Apply** the recommended modernization tasks directly from VS Code.
4. **Build & test** the updated application to validate the changes.
5. **Deploy** to Azure using the Terraform configuration provided in each sample's `infra/` folder.

---

## Cloning with submodules

The sample applications are included as **Git submodules**. After cloning this repository you must initialise and update the submodules to populate the sample folders:

```bash
git clone --recurse-submodules https://github.com/microsoft/github-copilot-modernization.git
```

If you already cloned without `--recurse-submodules`, run:

```bash
git submodule update --init --recursive
```

To pull the latest commits from the upstream submodule repositories at any time:

```bash
git submodule update --remote --merge
```

---

## Cloning with submodules

The sample applications are included as **Git submodules**. After cloning this repository you must initialise and update the submodules to populate the sample folders:

```bash
git clone --recurse-submodules https://github.com/microsoft/github-copilot-modernization.git
```

If you already cloned without `--recurse-submodules`, run:

```bash
git submodule update --init --recursive
```

To pull the latest commits from the upstream submodule repositories at any time:

```bash
git submodule update --remote --merge
```

---

## Getting started

Each sample folder has its own `README.md` with full step-by-step instructions, including a **Dev Container** definition so you don't need to install any language runtime, build tools, or cloud CLIs on your local machine.

- **Java sample** → [`java/PhotoAlbum-Java/README.md`](java/PhotoAlbum-Java/README.md)
- **.NET sample** → [`dotnet/dotnet-migration-copilot-samples/README.md`](dotnet/dotnet-migration-copilot-samples/README.md)

---

## Prerequisites (all samples)

| Tool | Notes |
|---|---|
| [VS Code](https://code.visualstudio.com/) | Editor (required for VS Code extension workflow) |
| [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) | Runs each sample in an isolated container |
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine | Required by Dev Containers |
| [Git](https://git-scm.com/downloads) | Clone this repo and the sample repos |
| [GitHub CLI (`gh`)](https://cli.github.com/) v2.45.0+ | Required by the modernization CLI |
| **GitHub Copilot Modernization** extension | Install from the VS Code Marketplace (VS Code workflow) |
| **GitHub Copilot Modernization CLI** (`modernize`) | Terminal-based alternative — see install instructions below |

### Installing the Modernization CLI

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh | sh
source ~/.bashrc   # or source ~/.zshrc for Zsh
```

Or via Homebrew:

```bash
brew tap microsoft/modernize https://github.com/microsoft/modernize-cli
brew install modernize
```

**Windows:**

```powershell
winget install GitHub.Copilot.modernization.agent
```

Then authenticate with GitHub:

```bash
gh auth login
modernize   # launch interactive TUI
```

Key CLI commands:

```bash
modernize assess                              # analyse the codebase
modernize plan create "<modernization goal>"  # e.g. "upgrade to Spring Boot 3"
modernize plan execute                        # apply the generated plan
```

> Full CLI reference: <https://learn.microsoft.com/azure/developer/github-copilot-app-modernization/modernization-agent/cli-commands>

winget install Microsoft.DotNet.SDK.10
dotnet tool install -g dotnet-appcat