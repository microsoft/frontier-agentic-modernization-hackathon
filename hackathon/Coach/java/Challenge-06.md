# Coach Guide – Challenge 06: Migrate the Database to Azure (Java Track)

## Purpose

This challenge takes the squad through a **production-grade data migration** from the Oracle XE database (running as a Docker container in the legacy stack) to the Azure Database for PostgreSQL Flexible Server provisioned in Challenge 03. Students use **Ora2Pg** — an offline Oracle-to-PostgreSQL converter — to export the schema and data, then import it using `psql`. This is a lightweight, deterministic approach that avoids DMS complexity and works well for the Oracle → PostgreSQL migration path. This is the final capstone step: all application state now lives in a managed, fully cloud-native PostgreSQL service.

A working reference for the Azure infrastructure already lives in `Coach/Resources/java/infra/aca/`. The `azurerm_postgresql_flexible_server` resource provisioned there is the migration target.

---

## Mini-Lecture (10 min before challenge)

Cover:

- **Why data migration is a separate concern from code modernisation.** Challenges 02–05 moved the application stack. This challenge moves the *data* — a required step before decommissioning the Oracle container.
- **Oracle → PostgreSQL: key differences to be aware of:**
  - *Sequences vs `AUTO_INCREMENT` / `SERIAL` / `GENERATED ALWAYS AS IDENTITY`*: Oracle uses explicit named sequences; Hibernate ORM abstracts these, but raw SQL scripts need adjustment. Ora2Pg converts these automatically.
  - *Data type mappings*: `VARCHAR2` → `VARCHAR`, `NUMBER` → `NUMERIC`/`INTEGER`, `CLOB`/`BLOB` → `TEXT`/`BYTEA`, `DATE` (with time) → `TIMESTAMP`. Ora2Pg handles these mappings.
  - *`ROWNUM` vs `LIMIT`*: Oracle pagination idiom differs; not relevant here since the app uses Hibernate, but relevant for any native queries.
  - *Case sensitivity*: Oracle identifiers are case-insensitive by default; PostgreSQL lowercases unquoted identifiers. Ora2Pg preserves quoting where necessary.
- **Ora2Pg for Oracle → PostgreSQL:**
  - Ora2Pg is a **Perl-based offline converter** that exports Oracle schema and data to PostgreSQL-compatible SQL scripts.
  - No runtime network dependency like DMS; runs locally against the Oracle container and generates a SQL file.
  - The generated SQL is deterministic and repeatable; students can run it multiple times without side effects (idempotent).
  - Limitations: Does not convert triggers, stored procedures, or packages (not relevant for PhotoAlbum, which uses Hibernate).
- **Hibernate `ddl-auto` lifecycle:** The modernized app sets `spring.jpa.hibernate.ddl-auto=create`, which drops and recreates the schema on every cold start. After the data migration, students must switch this to `validate` or `none` to preserve the migrated data.
- **Connection string hygiene:** Credentials must come from Azure Key Vault (already wired in Challenge 04), not hardcoded in `application.properties`.

---

## Pre-requisites

| Tool | Install / Notes |
|---|---|
| Oracle XE container running | `docker compose up -d` in `Resources/java/PhotoAlbum-Java/` |
| **Ora2Pg** | `brew install ora2pg` (macOS) or `sudo apt-get install ora2pg` (Linux) or [GitHub releases](https://github.com/darold/ora2pg/releases) (Windows/WSL) |
| `psql` CLI (import + validation) | `sudo apt-get install postgresql-client` or [Windows installer](https://www.postgresql.org/download/windows/) |
| Azure CLI | already installed from Challenge 00 |
| Java application seeded with data | Run the legacy Oracle-backed app at least once to populate the `photos` table |

The squad must have completed Challenge 03 (`terraform apply` succeeded) so the PostgreSQL Flexible Server and `photoalbum` database exist.

---

## Expected Findings / Key Steps

### 1 — Start the legacy Oracle stack and seed data

```bash
cd Resources/java/PhotoAlbum-Java
docker compose up -d
```

Wait ~60 seconds for Oracle XE to be ready (check with `docker compose logs oracle-db`). The `photoalbum` schema is created by the init scripts in `oracle-init/`. Run the legacy application against Oracle once to populate the `photos` table:

```bash
# Switch to Oracle datasource temporarily (see legacy docker-compose.yml env vars)
./mvnw spring-boot:run
```

Upload 2–3 photos through the UI (`http://localhost:8080`), then stop the application. Confirm data in Oracle:

```bash
# Connect to Oracle with SQL*Plus to confirm data
sqlplus photoalbum/photoalbum@localhost:1521/FREEPDB1 <<'EOF'
SELECT COUNT(*) FROM photoalbum.photos;
EXIT;
EOF
```

Expected: ≥ 2 rows.

### 2 — Run Ora2Pg to export schema and data

Have students copy the reference `ora2pg.conf` from `Coach/Resources/java/ora2pg.conf` and customize the connection details:

```bash
# Navigate to the repository root
cd ~/PhotoAlbum-Java  # or wherever they cloned it

# Copy the template
cp ../../Coach/Resources/java/ora2pg.conf . # or download from coach resources

# Edit ora2pg.conf: update ORACLE_DSN, ORACLE_USER, ORACLE_PASSWORD if needed
# Default: ORACLE_DSN=dbi:Oracle:host=localhost;sid=FREEPDB1, user/pass = photoalbum

# Run Ora2Pg
ora2pg -c ora2pg.conf -o ./photoalbum.sql
```

Expected output: `photoalbum.sql` file created with ~500–1000 lines (depends on photo count).

Common issues:
- **`Can't connect to Oracle`**: Check Oracle container is running (`docker ps`), verify `ORACLE_DSN`, ensure `photoalbum` user exists.
- **`Missing Perl modules`**: Install `DBD::Oracle` manually: `sudo cpanm DBD::Oracle`.
- **Permission denied on output**: Ensure write permissions in the current directory.

### 3 — Import into Azure PostgreSQL using psql

Have students retrieve the Azure PostgreSQL connection details:
   Username: photoalbum   Password: photoalbum
   ```
4. Select the `PHOTOALBUM` schema.
5. Click **Run assessment** and review the report.

**Expected assessment result:**

| Finding | Explanation |
|---|---|
| `photos` table — `BLOB` column (`photo_data`) | Maps to `BYTEA` in PostgreSQL. DMS handles the conversion automatically. |
| UUID stored as `VARCHAR(36)` | Maps to `VARCHAR(36)` in PostgreSQL. No issue. |
| `TIMESTAMP DEFAULT CURRENT_TIMESTAMP` | Supported natively in PostgreSQL. |
| No stored procedures, packages, or triggers | This schema is Hibernate-managed; no PL/SQL artifacts. |

Students should see **0 blockers**. If the assessment flags the `BLOB` column as a warning, explain that this is informational — DMS will convert `BLOB` to `BYTEA` automatically for the migration.

> **Note for coaches:** If students added `caption`, `altText`, and `tags` columns in Challenge 05, those are plain `VARCHAR` columns and present no migration concerns.

### 3 — Create the DMS migration project

1. In the Azure Database Migration Service wizard, select **Oracle → Azure Database for PostgreSQL Flexible Server**.
2. **Target connection:**
   - Host: `<postgres-fqdn>` (from `terraform output db_fqdn` in `Resources/java/infra/aca/`)
   - Port: `5432`
   - Database: `photoalbum`
   - Username / Password: from Key Vault (`db-username`, `db-password`) or Terraform variables.
3. **Migration mode:** Offline.
4. **Schema selection:** Select the `PHOTOALBUM` schema → `photos` table.
5. **DMS Integration Runtime:** Install the self-hosted Integration Runtime on the local machine (the same machine running the Oracle container). Follow the wizard's guided installation steps.
6. Start migration.

### 4 — Monitor migration progress

DMS shows per-table row counts and status. The `photos` table should complete within seconds for a small dataset.

Common error patterns:

**"ORA-01017: invalid username/password"**  
The Oracle container's `photoalbum` user credentials. Verify with `sqlplus photoalbum/photoalbum@localhost:1521/FREEPDB1`.

**"FATAL: password authentication failed for user"** (PostgreSQL side)  
The Key Vault secret `db-password` does not match what Terraform set on the Flexible Server. Retrieve the actual password with:
```bash
az keyvault secret show --vault-name <kv-name> --name db-password --query value -o tsv
```
and compare with `az postgres flexible-server show`.

**"column photo_data is of type bytea but expression is of type oid"**  
DMS version mismatch. Update to the latest DMS release; the BLOB→BYTEA conversion is fixed in DMS 6.x+.

### 5 — Prevent Hibernate from wiping the migrated data

**Critical step.** The modernized app sets `spring.jpa.hibernate.ddl-auto=create`, which drops and recreates tables on every startup. Change this to `validate` before running the modernized app against the populated PostgreSQL database:

In `Resources/java/PhotoAlbum-Java/src/main/resources/application.properties`:

```properties
# BEFORE migration
spring.jpa.hibernate.ddl-auto=create

# AFTER migration — preserves existing data
spring.jpa.hibernate.ddl-auto=validate
```

If using Azure Container Apps, update the `JAVA_OPTS` or use an environment variable override:
```hcl
env {
  name  = "SPRING_JPA_HIBERNATE_DDL_AUTO"
  value = "validate"
}
```

### 6 — Validate the migration

Connect to the Azure PostgreSQL target using `psql` and run:

```sql
-- Row count validation
SELECT 'photos' AS table_name, COUNT(*) AS row_count FROM photos;

-- Sample data spot-check
SELECT id, original_file_name, mime_type, file_size, uploaded_at
FROM photos
ORDER BY uploaded_at DESC
LIMIT 5;

-- BYTEA column integrity: confirm photo_data is not null for rows that had blobs
SELECT COUNT(*) AS rows_with_photo_data
FROM photos
WHERE photo_data IS NOT NULL;
```

The counts and sample data must match the Oracle source counts from step 1.

### 7 — Point the modernized application at the migrated data

The Container App provisioned in Challenge 03 already connects to Azure PostgreSQL using the env vars `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD` (sourced from Key Vault via Challenge 04). After changing `ddl-auto` to `validate` and redeploying, the application reads the migrated data directly.

Local development verification:

```bash
# Set env vars to point at Azure PostgreSQL
export DB_HOST=<postgres-fqdn>
export DB_PORT=5432
export DB_NAME=photoalbum
export DB_USERNAME=photoalbum
export DB_PASSWORD=<from-keyvault>
export SPRING_JPA_HIBERNATE_DDL_AUTO=validate

./mvnw spring-boot:run
```

Navigate to `http://localhost:8080` — the photos uploaded to Oracle should appear in the gallery.

### 8 — Decommission the Oracle container

Once validation passes and the modernized app is confirmed to read from Azure PostgreSQL:

```bash
docker compose down -v   # removes Oracle container + volumes
```

This is the final proof that the migration is complete and the legacy database is no longer needed.

---

## Common Pitfalls

| Symptom | Root Cause | Coaching Hint |
|---|---|---|
| DMS cannot connect to Oracle | Oracle XE container not running or not yet ready | Run `docker compose ps` and `docker compose logs oracle-db`; wait for "DATABASE IS READY TO USE" in logs |
| `ORA-12541: No listener` | Oracle listener not started inside container | Restart with `docker compose restart oracle-db`; listener starts automatically after ~45 s |
| PostgreSQL target shows empty `photos` table after app starts | `ddl-auto=create` wiped the migrated data on app startup | Change to `ddl-auto=validate` **before** starting the modernized app after migration |
| `photo_data BYTEA` shows null for all rows | Migration ran before photos were uploaded | Seed Oracle with at least one photo upload first, then re-run DMS migration |
| `relation "photos" does not exist` (PostgreSQL error) | Hibernate schema not yet created on target | Run app once with `ddl-auto=create` on empty target to create schema, then wipe and migrate data again (or use `ddl-auto=none` and create schema via DDL export from DMS assessment) |
| Self-hosted Integration Runtime install fails | .NET 6 runtime not present on the migration machine | Install .NET 6 runtime: `sudo apt-get install -y dotnet-runtime-6.0` on Linux |
| Row count mismatch after migration | Concurrent inserts during offline migration window | Acceptable for a hackathon. In production, quiesce the application before offline migration |
| `application.properties` still contains `spring.datasource.password=photoalbum` | Key Vault integration removed during testing | Restore `spring.datasource.password=${DB_PASSWORD:${azure.keyvault.db-password:photoalbum}}` |

---

## Success Criteria

| Criterion | Notes |
|---|---|
| DMS assessment shows 0 blockers | Students must show the assessment report |
| All rows in `photos` table match source row count | Verified by validation query in step 6 |
| `photo_data` BLOB→BYTEA conversion complete | Spot-check query returns count > 0 (if photos were uploaded) |
| Application running against Azure PostgreSQL shows gallery with migrated photos | Visit `/` in the deployed Container App |
| `spring.jpa.hibernate.ddl-auto` is `validate` (not `create`) in the deployed configuration | Check env vars in Container App: `az containerapp show --name ... --query "properties.template.containers[0].env"` |
| Oracle Docker container is stopped and removed | `docker ps` shows no `oracle-db` container |
| No database credentials in `application.properties` or Container App env vars in plain text | Passwords must come from Key Vault or Managed Identity |

---

## Learning Resources

- [Azure Database Migration Service — Oracle to PostgreSQL](https://learn.microsoft.com/azure/dms/tutorial-oracle-azure-postgresql-online)
- [Azure Database Migration Service overview](https://learn.microsoft.com/azure/dms/dms-overview)
- [Oracle to Azure PostgreSQL migration guide](https://learn.microsoft.com/azure/postgresql/migrate/how-to-migrate-from-oracle)
- [Oracle to PostgreSQL data type mapping](https://learn.microsoft.com/azure/postgresql/migrate/how-to-migrate-from-oracle#data-types)
- [Azure Database for PostgreSQL Flexible Server overview](https://learn.microsoft.com/azure/postgresql/flexible-server/overview)
- [Hibernate `ddl-auto` property reference](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#configurations-hbmddl)
- [Self-hosted Integration Runtime for DMS](https://learn.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime)
- [`psql` — PostgreSQL interactive terminal](https://www.postgresql.org/docs/current/app-psql.html)
