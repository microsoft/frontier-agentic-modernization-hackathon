[< Previous Challenge](./Challenge-03.md) — **[Home](../../README.md)** — [Next Challenge >](./Challenge-05.md)

# Challenge 04 — Migrate the Database to Azure SQL

## Introduction

The eShopOnWeb solution uses **two separate EF Core databases**:

| Context | Database | Contents |
|---------|----------|----------|
| `CatalogContext` | `Microsoft.eShopOnWebCatalogDb` | Products, catalog types, catalog brands |
| `AppIdentityDbContext` | `Microsoft.eShopOnWebIdentityDb` | ASP.NET Core Identity users and roles |

In Challenge 03 you provisioned an Azure SQL Database and deployed containers that point at it — but the schema has not been created and no data exists. This challenge completes that work and validates the end-to-end stack.

## Description

### Step 1 — Apply EF Core Migrations to Azure SQL

```bash
cd Student/Resources/net8/eShopOnWeb

# Catalog database
dotnet ef database update \
  --context CatalogContext \
  --project src/Infrastructure/Infrastructure.csproj \
  --startup-project src/Web/Web.csproj \
  --connection "<azure-sql-catalog-connection-string>"

# Identity database
dotnet ef database update \
  --context AppIdentityDbContext \
  --project src/Infrastructure/Infrastructure.csproj \
  --startup-project src/Web/Web.csproj \
  --connection "<azure-sql-identity-connection-string>"
```

### Step 2 — Seed and Validate Data

The application seeds data on first startup when the database is empty. Trigger seeding by starting the Web Container App (or running locally with Azure SQL as target) and verify:

- The catalog page shows all products with images loading from Blob Storage
- Login works with `demouser@microsoft.com` / `Pass@word1`
- The admin user can access `/admin` and the Blazor admin panel loads

### Step 3 — Row-Parity Check

Run the following against your Azure SQL Catalog database:

```sql
SELECT 'CatalogItems'  AS [Table], COUNT(*) AS [Rows] FROM CatalogItems
UNION ALL
SELECT 'CatalogBrands', COUNT(*) FROM CatalogBrands
UNION ALL
SELECT 'CatalogTypes',  COUNT(*) FROM CatalogTypes;
```

Expected counts match the local in-memory seed data.

### Step 4 — End-to-End Smoke Test

- Browse catalog → all products display with Blob Storage images
- Add items to basket → basket persists across requests
- Place an order → order appears in the database + Service Bus message is published
- Log in as admin → Blazor admin panel shows order history

## Success Criteria

To complete this challenge successfully, demonstrate:

1. Both `dotnet ef database update` commands complete without errors against Azure SQL
2. The catalog page shows the seeded products when running fully on Azure
3. Login with `demouser@microsoft.com` / `Pass@word1` succeeds
4. Row counts in Azure SQL match expected seed data
5. An end-to-end order flow completes without errors
6. **Explain to your coach** — eShopOnWeb uses two separate `DbContext` classes and two separate databases. What is the architectural benefit of this separation, and what operational overhead does it introduce?

## Learning Resources

- [EF Core migrations — applying to a database](https://learn.microsoft.com/ef/core/managing-schemas/migrations/applying)
- [EF Core — multiple DbContexts](https://learn.microsoft.com/ef/core/dbcontext-configuration/)
- [Azure SQL connection strings](https://learn.microsoft.com/azure/azure-sql/database/connect-query-dotnet-core)
- [EF Core 10 — what's new](https://learn.microsoft.com/ef/core/what-is-new/ef-core-10.0/whatsnew)

## Tips

- Use the `--connection` flag on `dotnet ef database update` to target Azure SQL without modifying `appsettings.json`.
- If you see `Cannot open server requested by the login`, add your IP to the Azure SQL firewall rules in the portal.
- The two `DbContext` migration histories are tracked independently — run both `database update` commands separately.
- If EF Core reports a migration mismatch after the .NET 10 upgrade: `dotnet ef database drop` then `dotnet ef database update` to recreate from scratch.
