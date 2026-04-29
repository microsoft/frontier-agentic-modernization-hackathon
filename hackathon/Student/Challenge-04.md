[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

# Challenge 04 – Containerize & Deploy to Azure Container Apps

## Introduction

With both applications modernized, the next step is to package them as container images and deploy them to **Azure Container Apps** — a serverless container hosting platform that provides automatic scaling, built-in networking, and deep integration with Azure services.

Each application folder already contains an `infra/` directory with a skeleton Terraform configuration. Your task is to complete these configurations to provision all required Azure resources and deploy both containers.

## Description

Containerize and deploy both modernized applications to Azure:

**For the Java application (`hackathon/Student/Resources/java/PhotoAlbum-Java`):**
- Verify or update the `Dockerfile` to build on a Java 21 base image
- Complete the Terraform configuration in `hackathon/Student/Resources/java/infra/` to provision:
  - Azure Container Apps environment and app
  - Azure Database for PostgreSQL (Flexible Server)
  - Azure Blob Storage account and container

**For the .NET application (`hackathon/Student/Resources/dotnet/`):**
- Create or verify a `Dockerfile` that builds and runs the app on .NET 9
- Complete the Terraform configuration in `hackathon/Student/Resources/dotnet/infra/` to provision:
  - Azure Container Apps environment and app
  - Azure SQL Database
  - Azure Blob Storage account and container
  - Azure Service Bus namespace and queue

**Deployment steps for both:**
- Build and push each container image to Azure Container Registry (or GitHub Container Registry)
- Apply the Terraform configuration: `terraform init && terraform apply`
- Verify that the deployed applications are reachable via their Azure Container Apps URLs
- Confirm that data flows correctly to and from all Azure services

> **Hint:** Azure Container Apps can pull images directly from a registry. Make sure your Container App is configured with the correct registry credentials or uses Managed Identity for ACR access.

> **Hint:** Use Terraform `output` values to retrieve the Container App URLs after `terraform apply`.

> **Hint:** Connection strings for Azure services should be passed to the Container Apps as **environment variables** or **secrets** — do not hard-code them in the container image.

## Success Criteria

To complete this challenge successfully, demonstrate:

- Both container images build successfully with `docker build`
- `terraform apply` completes without errors for both applications
- The Java PhotoAlbum app is accessible at its Azure Container Apps URL and photos can be uploaded and viewed
- The ContosoUniversity .NET app is accessible at its Azure Container Apps URL and all CRUD operations work
- Azure Portal shows active connections from the Container Apps to Azure Database for PostgreSQL, Azure SQL Database, Azure Service Bus, and Azure Blob Storage
- No Oracle or MSMQ dependencies remain anywhere in the infrastructure

## Learning Resources

- [Azure Container Apps overview](https://learn.microsoft.com/azure/container-apps/overview)
- [Deploy to Azure Container Apps with Terraform](https://learn.microsoft.com/azure/container-apps/terraform)
- [Azure Container Registry — push and pull images](https://learn.microsoft.com/azure/container-registry/container-registry-get-started-docker-cli)
- [Azure Database for PostgreSQL Flexible Server — Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server)
- [Azure SQL Database — Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)
- [Azure Service Bus — Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace)
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
