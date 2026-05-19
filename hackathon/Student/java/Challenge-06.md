[< Previous Challenge](./Challenge-05.md) - **[Home](../../README.md)**

# Challenge 06 – Migrate the PhotoAlbum Database to Azure PostgreSQL

## Introduction

The modernized PhotoAlbum runs on Spring Boot 3 / Java 21 in Azure Container Apps with Azure Database for PostgreSQL Flexible Server, Azure Key Vault, and Azure Blob Storage. However, the **production data** from the legacy application still lives in the Oracle XE database running as a Docker container. Before shutting down that container permanently, the data must be **migrated to Azure Database for PostgreSQL Flexible Server** with full fidelity.

In this challenge you will use **Ora2Pg** — an offline Oracle-to-PostgreSQL schema/data converter — to export the legacy Oracle schema and data, then import it into Azure Database for PostgreSQL Flexible Server using `psql`. This is a lightweight, deterministic approach that avoids DMS complexity and works well for the Oracle → PostgreSQL migration path.

## Description

Perform a complete offline database migration from the legacy Oracle XE database to the Azure Database for PostgreSQL Flexible Server provisioned in Challenge 03.

**Prepare the source**

- Start the legacy Oracle stack (`docker compose up -d` in `Resources/java/PhotoAlbum-Java/`).
- Ensure the Oracle `photoalbum` schema contains data by running the legacy application once and uploading at least 2–3 photos.
- Note the row count in `photoalbum.photos` — you will verify this count matches after migration.

**Install Ora2Pg**

Ora2Pg is an Oracle-to-PostgreSQL converter. Install it on your local machine:

- **macOS**: `brew install ora2pg`
- **Linux (Ubuntu/Debian)**: `sudo apt-get install -y perl cpanminus && sudo cpanm DBD::Oracle Ora2Pg` (or `sudo apt-get install -y ora2pg` if available)
- **Windows**: Download from [Ora2Pg GitHub releases](https://github.com/darold/ora2pg/releases) or use WSL

Verify installation: `ora2pg --version`

**Export the Oracle schema and data using Ora2Pg**

Create an `ora2pg.conf` configuration file. Use the reference template from [Coach Resources](../../Coach/Resources/java/ora2pg.conf):

```ini
[ora2pg]
# Oracle source connection
ORACLE_HOME=/usr/lib/oracle/...  # or leave blank if sqlplus/Oracle libs are in PATH
ORACLE_DSN=dbi:Oracle:host=localhost;sid=FREEPDB1
ORACLE_USER=photoalbum
ORACLE_PASSWORD=photoalbum

# Export schema and data
SCHEMA=PHOTOALBUM
OWNER=photoalbum
TYPE=TABLE,SEQUENCE,INDEX
EXPORT_SCHEMA=1
```

Run Ora2Pg to generate a SQL dump:

```bash
ora2pg -c ora2pg.conf -o ./photoalbum.sql
```

This creates a PostgreSQL-compatible SQL script containing:
- Table definitions (Oracle types mapped to PostgreSQL: `VARCHAR2` → `VARCHAR`, `BLOB` → `BYTEA`, etc.)
- Sequences and indexes
- Data insert statements

**Migrate to Azure PostgreSQL**

1. Get the Azure PostgreSQL Flexible Server connection details:
   ```bash
   cd Resources/java/infra/aca/
   terraform output db_fqdn  # e.g., wth-photoalbum-db.postgres.database.azure.com
   terraform output db_admin_username  # e.g., azureadmin@wth-photoalbum-db
   ```

2. Connect to Azure PostgreSQL using `psql` and import the SQL dump:
   ```bash
   export PGPASSWORD="<your-db-admin-password>"
   psql -h <db-fqdn> -U <admin-user> -d photoalbum < photoalbum.sql
   ```
   (Replace placeholders with actual values from `terraform output`.)

3. Monitor the import for errors (should complete without fatal errors).

**Critical: protect the migrated data**

- The modernized application has `spring.jpa.hibernate.ddl-auto=create` in `application.properties`. This value **drops and recreates all tables** on every application start — which would wipe the freshly migrated data.
- Change this setting to `validate` before starting or redeploying the modernized application against the populated PostgreSQL database.

**Validation**

- Connect to the Azure PostgreSQL target using `psql` or the Azure Portal Query editor.
- Run row-count queries to confirm the `photos` table count matches the Oracle source.
- Spot-check that image binary data (`photo_data` column) was converted from Oracle `BLOB` to PostgreSQL `BYTEA` correctly.
- Start the modernized application pointing at Azure PostgreSQL and confirm the photo gallery loads with the migrated photos.

**Decommission the legacy database**

- Once the migrated data is validated and the modernized application is running on Azure, stop and remove the Oracle Docker container:
  ```bash
  docker compose down -v
  ```
- This is the definitive proof that the migration succeeded and the legacy system is no longer needed.

> **Hint:** Run `terraform output db_fqdn` inside `Resources/java/infra/aca/` to retrieve the PostgreSQL Flexible Server hostname provisioned in Challenge 03.

> **Hint:** If you encounter `psql: error: FATAL: SSL connection error`, or similar SSL issues, add `-sslmode=disable` to your `psql` command: `psql -h <db-fqdn> ... -sslmode=disable < photoalbum.sql` or disable SSL in Azure Portal (Connection Security).

> **Hint:** If Ora2Pg cannot connect to Oracle, ensure:
>   - The Oracle container is running: `docker ps | grep oracle-db`
>   - Oracle is listening on port 1521: `netstat -an | grep 1521` or `ss -an | grep 1521`
>   - The TNS connection string is correct: `ORACLE_DSN=dbi:Oracle:host=localhost;sid=FREEPDB1`
>   - Oracle `photoalbum` user credentials are correct (default password often same as username)

> **Hint:** Set `spring.jpa.hibernate.ddl-auto=validate` (or pass the env var `SPRING_JPA_HIBERNATE_DDL_AUTO=validate`) **before** pointing the application at the populated PostgreSQL database. With `create`, Hibernate will silently destroy all migrated data on the first application start.

> **Hint:** Ora2Pg automatically converts Oracle `BLOB` to PostgreSQL `BYTEA`. The entity definition does not need to change; Hibernate handles both transparently.

## Success Criteria

To complete this challenge, demonstrate:

- Ora2Pg successfully exports the `PHOTOALBUM` schema and `photos` table data to a SQL file without errors.
- The SQL file imports into Azure PostgreSQL without fatal errors.
- The `photos` table in Azure PostgreSQL has a **row count matching the Oracle source** — verified with a `SELECT COUNT(*) FROM photos` query on both sides.
- The `photo_data` column in PostgreSQL contains `BYTEA` data (not null) for rows that had blobs in Oracle.
- The deployed PhotoAlbum Container App displays the migrated photos in the gallery — no re-upload required.
- `spring.jpa.hibernate.ddl-auto` is set to `validate` (not `create`) in the running configuration — confirmed via `az containerapp show`.
- The Oracle Docker container has been **stopped and removed** (`docker ps` shows no `oracle-db` container).
- No database passwords appear in plain text in `application.properties` or Container App environment variables — credentials come from Azure Key Vault.

## Learning Resources

- [Ora2Pg Documentation](https://github.com/darold/ora2pg)
- [Ora2Pg Installation Guide](https://ora2pg.darold.net/installation.html)
- [Ora2Pg Configuration Reference](https://ora2pg.darold.net/configuration.html)
- [Oracle to PostgreSQL data type mapping reference](https://learn.microsoft.com/azure/postgresql/migrate/how-to-migrate-from-oracle#data-types)
- [Azure Database for PostgreSQL Flexible Server overview](https://learn.microsoft.com/azure/postgresql/flexible-server/overview)
- [Self-hosted Integration Runtime installation](https://learn.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime)
- [`psql` — PostgreSQL interactive terminal](https://www.postgresql.org/docs/current/app-psql.html)
- [Hibernate `ddl-auto` reference](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#configurations-hbmddl)
