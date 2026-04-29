# Coach Guide – Challenge 04: Containerize & Deploy to Azure Container Apps

## Purpose

This challenge brings both modernization tracks together and validates the work done in Challenges 02 and 03 in a real Azure environment. Attendees gain hands-on experience with containerization and infrastructure-as-code using Terraform.

## Mini-Lecture (10 min before challenge)

Cover:
- What Azure Container Apps provides: serverless containers, auto-scaling, built-in ingress
- The Terraform workflow: `init` → `plan` → `apply`
- The role of Azure Container Registry: build once, pull from any environment
- Secret management for containers: environment variables vs. Key Vault references (foreshadow Challenge 05)

## Terraform Resource Checklist

### Java App (`hackathon/Student/Resources/java/infra/`)
Terraform should provision:
- `azurerm_resource_group`
- `azurerm_container_registry`
- `azurerm_postgresql_flexible_server` + `azurerm_postgresql_flexible_server_database`
- `azurerm_storage_account` + `azurerm_storage_container`
- `azurerm_container_app_environment`
- `azurerm_container_app` (with env vars for PostgreSQL DSN and storage connection string)

### .NET App (`hackathon/Student/Resources/dotnet/infra/`)
Terraform should provision:
- `azurerm_resource_group`
- `azurerm_container_registry`
- `azurerm_mssql_server` + `azurerm_mssql_database`
- `azurerm_storage_account` + `azurerm_storage_container`
- `azurerm_servicebus_namespace` + `azurerm_servicebus_queue`
- `azurerm_container_app_environment`
- `azurerm_container_app` (with env vars for SQL connection string, blob connection string, service bus connection string)

## Common Pitfalls

| Issue | Hint to give |
|---|---|
| `docker build` fails because target runtime not in base image | Ask: "What base image does your Dockerfile use? Does it match the target runtime?" |
| ACR push fails with `unauthorized` | Run `az acr login --name <registry-name>` before `docker push` |
| Container App can't connect to PostgreSQL | Check that the PostgreSQL server firewall rule allows Azure services, or use VNet integration |
| `terraform apply` fails on resource name conflict | Azure resource names must be globally unique — use a random suffix or prefix |
| Environment variables not populated in container | Check the Container App configuration in Azure Portal → Container App → Containers → Environment variables |
| `pg_hba.conf` authentication error from Java app | Ensure the connection string uses SSL: `?sslmode=require` |
| Service Bus connection refused | Verify the Service Bus namespace name and queue name match the connection string |

## Azure Resource Naming Tips

Suggest squads use a consistent naming pattern, e.g.:
```
<hack-prefix>-<resource-type>-<track>-<random>
```
Example: `wth-ca-java-abc123`, `wth-sql-dotnet-abc123`

## Success Criteria Notes

- The primary verification is accessing both apps via their Container Apps URLs in a browser
- Azure Portal screenshots showing active connections to Azure services are acceptable as evidence
- If the Java app is running but photo upload to Blob Storage fails, that is a partial success — focus on getting the app running first
- The .NET app's Service Bus integration can be verified by triggering the notification flow and checking Service Bus Explorer in Azure Portal
