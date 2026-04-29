# GitHub Copilot App Modernization

> **Bring your legacy applications into the modern era — using AI.**

Millions of lines of production code still run on .NET Framework 4.8, Java 8, and Oracle Database. Migrating them by hand is slow, risky, and expensive. This repository shows a better way: using **GitHub Copilot Modernization** to assess, plan, and execute migrations automatically — with AI doing the heavy lifting.

You will find two real legacy applications here, each with a hands-on modernization path to Azure Container Apps. And if you want to run a team learning event, there is a full **What The Hack** style hackathon included.

---

## The Applications

| Application | Legacy Stack | Target Stack |
|---|---|---|
| [ContosoUniversity](hackathon/Student/Resources/dotnet/dotnet-migration-copilot-samples/) | ASP.NET MVC 5 · .NET Framework 4.8 · MSMQ · Local file storage | ASP.NET Core · .NET 9 · Azure Service Bus · Azure Blob Storage |
| [PhotoAlbum](hackathon/Student/Resources/java/PhotoAlbum-Java/) | Spring Boot 2.7 · Java 8 · Oracle Database · In-DB BLOBs | Spring Boot 3.x · Java 21 · Azure Database for PostgreSQL · Azure Blob Storage |

Both applications deploy to **Azure Container Apps** using Terraform infrastructure-as-code.

---

## How It Works

GitHub Copilot Modernization analyses your codebase and drives the migration through three steps:

```
modernize assess                              # scan the codebase, identify blockers
modernize plan create "<migration goal>"      # AI generates a structured migration plan
modernize plan execute                        # apply the plan — Copilot writes the changes
```

The tool handles the mechanical work — dependency upgrades, namespace renames, API replacements — while Copilot Chat helps you resolve the parts that require judgment.

---

## Getting Started

### 1. Clone with submodules

The sample applications are included as Git submodules:

```bash
git clone --recurse-submodules https://github.com/microsoft/github-copilot-modernization.git
```

Already cloned? Initialise the submodules now:

```bash
git submodule update --init --recursive
```

### 2. Install the tools

| Tool | Install |
|---|---|
| [VS Code](https://code.visualstudio.com/) | Download from code.visualstudio.com |
| [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) | VS Code extension marketplace |
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Required by Dev Containers |
| [GitHub CLI (`gh`)](https://cli.github.com/) v2.45.0+ | `winget install GitHub.cli` / `brew install gh` |
| **GitHub Copilot Modernization** extension | VS Code Marketplace — search "Copilot Modernization" |
| [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) | For provisioning Azure resources |
| [Terraform](https://developer.hashicorp.com/terraform/install) | For infrastructure-as-code deployments |

**Prefer the terminal?** Install the `modernize` CLI instead of the VS Code extension:

```bash
# Linux / macOS
curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh | sh
source ~/.bashrc   # or ~/.zshrc

# macOS (Homebrew)
brew tap microsoft/modernize https://github.com/microsoft/modernize-cli
brew install modernize

# Windows
winget install GitHub.Copilot.modernization.agent
```

Then authenticate and launch:

```bash
gh auth login
modernize   # opens the interactive TUI
```

> Full CLI reference: <https://learn.microsoft.com/azure/developer/github-copilot-app-modernization/modernization-agent/cli-commands>

### 3. Open a sample

Each application has its own `README.md` with full instructions and a **Dev Container** definition — no local runtime or build tools required.

- **Java** → [`hackathon/Student/Resources/java/PhotoAlbum-Java/README.md`](hackathon/Student/Resources/java/PhotoAlbum-Java/README.md)
- **.NET** → [`hackathon/Student/Resources/dotnet/dotnet-migration-copilot-samples/README.md`](hackathon/Student/Resources/dotnet/dotnet-migration-copilot-samples/README.md)

---

## Run It as a Hackathon

This repository includes a **[What The Hack](https://aka.ms/wth)**-format hackathon designed for teams of 3–5 people. Squads work through a series of challenges — no step-by-step instructions, just goals and success criteria — with a coach guiding the way.

👉 **[Start the hackathon →](hackathon/README.md)**

| Challenge | What you'll do |
|---|---|
| [00 – Prerequisites](hackathon/Student/Challenge-00.md) | Set up your environment and verify all tools are working |
| [01 – Assess](hackathon/Student/Challenge-01.md) | Run `modernize assess` on both apps; identify the migration blockers |
| [02 – Modernize Java](hackathon/Student/Challenge-02.md) | Spring Boot 2 / Java 8 / Oracle → Spring Boot 3 / Java 21 / PostgreSQL |
| [03 – Modernize .NET](hackathon/Student/Challenge-03.md) | .NET Framework 4.8 / MSMQ → .NET 9 / Azure Service Bus |
| [04 – Deploy to Azure](hackathon/Student/Challenge-04.md) | Containerize both apps and ship them to Azure Container Apps with Terraform |
| [05 – Secure & Observe *(stretch)*](hackathon/Student/Challenge-05.md) | Application Insights · Key Vault · Managed Identity · CI/CD |

> **Coaches:** The [Coach Guide](hackathon/Coach/README.md) contains solutions, event logistics, timing estimates, and hints for each challenge. Keep it away from attendees until after the event.

---

## Repository Structure

```
.
├── hackathon/
│   ├── README.md                          # Hackathon one-pager
│   ├── Student/
│   │   ├── Challenge-00.md … 05.md        # Attendee challenge guides
│   │   └── Resources/
│   │       ├── dotnet/                    # ContosoUniversity (.NET app + infra)
│   │       └── java/                      # PhotoAlbum (Java app + infra)
│   └── Coach/
│       ├── README.md                      # Event logistics & schedule
│       └── Challenge-00.md … 05.md        # Coach solutions & hints
└── .devcontainer/                         # Dev Container for this repo
```

---

## Contributing

Contributions are welcome — whether that's improving the sample applications, adding new modernization scenarios, or extending the hackathon challenges. Please open an issue or pull request.
