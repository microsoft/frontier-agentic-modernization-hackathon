# Coach Guide – Challenge 01: Assess the Legacy Applications

## Purpose

This challenge teaches attendees how to use `modernize assess` and builds the mental model for what needs to change before they touch any code. The debrief discussion after this challenge is critical — it sets the direction for Challenges 02 and 03.

## Mini-Lecture (10 min before challenge)

Cover:
- What `modernize assess` does: static analysis of dependencies, APIs, and patterns
- How to read the assessment report: severity levels, categories (compatibility, cloud readiness, security)
- The difference between issues the tool can auto-fix vs. issues requiring manual attention
- Briefly demo `modernize assess` in the terminal or VS Code extension on one of the apps

## Expected Assessment Findings

### Java – PhotoAlbum

Key issues the assessment should surface:
- **Spring Boot 2.x → 3.x:** `javax.*` → `jakarta.*` namespace migration, Spring Security config changes, Hibernate 6 breaking changes
- **Java 8 → 21:** Deprecated APIs, `java.util.Date` → `java.time`, potentially some reflection-based patterns
- **Oracle JDBC driver:** `ojdbc8` dependency — not available in public Maven repos without authentication
- **BLOB storage:** All photo data stored as BLOBs in Oracle — identified as a cloud readiness concern

### .NET – ContosoUniversity

Key issues the assessment should surface:
- **`System.Messaging` (MSMQ):** Not supported in .NET Core/5+ — critical blocker
- **`System.Web`:** The entire ASP.NET legacy stack — all controllers, filters, `HttpContext` must be migrated
- **`packages.config` / legacy `.csproj`:** Must be converted to SDK-style project
- **`Global.asax`:** Must be migrated to `Program.cs` host builder
- **Local file system (`Uploads/TeachingMaterials`):** Cloud readiness concern for containerized deployment
- **`Web.config`:** Must be converted to `appsettings.json`

## Debrief Discussion Guide

After each squad reviews their reports, facilitate a 10-minute debrief:

1. **What surprised you?** — Attendees often underestimate the `System.Web` scope for .NET
2. **What can be automated?** — Namespace changes, project file format, some dependency updates
3. **What needs manual work?** — MSMQ → Service Bus logic, Oracle → PostgreSQL schema/query differences, BLOB → Azure Blob migration
4. **How would you prioritise?** — Blockers first (MSMQ, `System.Web`), then quality improvements

## Success Criteria Notes

- The assessment report format may vary slightly between CLI and VS Code extension — both are acceptable
- "Top 3 migration blockers" is intentionally subjective — any reasonable answer is correct
- If the assessment does not surface MSMQ or Oracle as issues, the squad may have run the assessment on the wrong folder — coach them to re-run from the correct application root
