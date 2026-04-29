[< Previous Challenge](../README.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

# Challenge 00 – Prerequisites: Ready, Set, GO!

## Introduction

Before diving into application modernization, you need a working local environment with all required tools installed and authenticated. This challenge ensures everyone on your squad starts from the same baseline.

The repository uses **Git submodules** to include the sample applications. You must initialise the submodules before the source code of the legacy apps is available on your machine.

This repo also provides a **Dev Container** definition (`.devcontainer/`) that pre-installs most dependencies inside a Docker container — if you prefer that approach, opening the repo in VS Code with the Dev Containers extension will get you up and running quickly.

## Description

Set up your local development environment so you are ready to work with both sample applications:

- Install and verify all required tools listed in the [Prerequisites](../README.md#prerequisites) section of the hack README
- Clone the repository **with submodules** so that both `hackathon/Student/Resources/dotnet/dotnet-migration-copilot-samples/` and `hackathon/Student/Resources/java/PhotoAlbum-Java/` are populated
- Authenticate the GitHub CLI (`gh auth login`) and verify that the Modernization CLI or extension is active
- Verify your Azure subscription is accessible and you have permissions to create resources
- Confirm that each sample application can be built locally:
  - The Java app can be started with Docker Compose
  - The .NET app can be built with `dotnet build` (or `msbuild`) targeting .NET Framework 4.8

### Optional: Deploy the Legacy Applications to Azure VMs

To see both applications running in their **original, unmodified state** before starting the modernization, each application has a Terraform configuration that provisions a dedicated Azure VM and configures everything automatically.

This is recommended — it gives your squad a concrete "before" picture and validates that the original apps work end-to-end.

**Java app (PhotoAlbum — Ubuntu + Docker + Oracle):**
- Follow the steps in [`Resources/java/infra/vm/README.md`](../Resources/java/infra/vm/README.md)
- Runs at `http://<vm-ip>:8080` after ~10 minutes

**\.NET app (ContosoUniversity — Windows Server + IIS + SQL Express + MSMQ):**
- Follow the steps in [`Resources/dotnet/infra/vm/README.md`](../Resources/dotnet/infra/vm/README.md)
- Runs at `http://<vm-ip>` after ~20 minutes

> **Tip:** Your squad can deploy both VMs in parallel while other setup steps are running.

## Success Criteria

To complete this challenge successfully, demonstrate:

- `modernize --version` (CLI) or the GitHub Copilot Modernization extension shows as active in VS Code
- `gh auth status` returns your authenticated GitHub account
- `az account show` returns your Azure subscription
- Running `git submodule status` in the repo root shows both submodules at a valid commit hash (no leading `–`)
- The Java Photo Album application starts successfully via `docker-compose up` in `hackathon/Student/Resources/java/PhotoAlbum-Java/`
- The .NET ContosoUniversity project builds without errors
- *(Optional)* Both legacy apps are accessible at their Azure VM URLs

## Learning Resources

- [GitHub Copilot Modernization – Get Started](https://learn.microsoft.com/azure/developer/github-copilot-app-modernization/get-started)
- [Modernization CLI reference](https://learn.microsoft.com/azure/developer/github-copilot-app-modernization/modernization-agent/cli-commands)
- [Git submodules documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Dev Containers overview](https://code.visualstudio.com/docs/devcontainers/containers)
- [Terraform getting started](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)

