# Coach Guide – What The Hack: GitHub Copilot App Modernization

> ⚠️ **Do NOT share this folder with attendees during the event.** Content here contains solutions, hints, and coaching notes.

## Overview

This hack is designed for squads of 3–5 people. It covers two parallel modernization tracks:

| Track | Application | Legacy Stack | Target Stack |
|---|---|---|---|
| Java | PhotoAlbum | Spring Boot 2.7 / Java 8 / Oracle DB | Spring Boot 3.x / Java 21 / PostgreSQL + Azure Blob |
| .NET | ContosoUniversity | .NET Framework 4.8 / ASP.NET MVC 5 / MSMQ | .NET 10 / ASP.NET Core / Azure Service Bus + Blob |

Challenges 02 and 03 are designed to be parallelized within a squad — some members take Java, others take .NET. Both tracks converge in Challenge 04 (deployment).

## Event Logistics

### Recommended Schedule (Full Day)

| Time | Activity |
|---|---|
| 09:00 – 09:30 | Welcome, introductions, hack overview presentation |
| 09:30 – 10:00 | Challenge 00 — Prerequisites |
| 10:00 – 10:30 | Mini-lecture: What is GitHub Copilot Modernization? (demo the TUI) |
| 10:30 – 11:00 | Challenge 01 — Assessment |
| 11:00 – 11:15 | Debrief: discuss assessment results, split squad into Java/NET tracks |
| 11:15 – 13:00 | Challenge 02 — Modernize the application (per track) |
| 13:00 – 14:00 | Lunch break |
| 14:00 – 15:30 | Continue Challenge 02 |
| 15:30 – 16:30 | Challenge 03 — Deploy to Azure |
| 16:30 – 17:15 | Challenge 04 — Observe, Validate & Secure (core) |
| 17:15 – 17:30 | Challenge 05 (stretch, optional) — Infuse AI |
| 17:30 – 18:00 | Wrap-up, retrospective, demo |

### Squad Size

- **Ideal:** 3–5 people
- **Minimum:** 2 people (one per track in Challenge 02)
- **Maximum:** 5 people (assign roles: Java lead, .NET lead, infra lead, tester, documentarian)

## Coach Responsibilities

- **Do not give answers** — give hints and ask questions that help the squad discover the solution
- Deliver a short (5–10 minute) mini-lecture before Challenges 01, 02, and 03 to set context
- Monitor squad progress and time — if a squad is stuck for more than 20 minutes, intervene with a targeted hint
- Be familiar with both the `modernize` CLI and the VS Code extension so you can demonstrate either

## Common Issues Across All Challenges

| Issue | Resolution |
|---|---|
| `gh auth status` fails | Run `gh auth login` and complete browser OAuth flow |
| Submodules empty after clone | Run `git submodule update --init --recursive` |
| Docker not running | Ensure Docker Desktop is started before any `docker-compose` or Dev Container commands |
| `modernize` command not found | Re-run the install script; ensure `~/.local/bin` or equivalent is on `PATH` |
| Azure CLI not logged in | Run `az login` |

## Challenge Notes

Coach notes live in per-track subfolders. Pick the track you are coaching:

**.NET track**
- [Challenge 00 – Prerequisites](./dotnet/Challenge-00.md)
- [Challenge 01 – Assess](./dotnet/Challenge-01.md)
- [Challenge 02 – .NET Modernization](./dotnet/Challenge-02.md)
- [Challenge 03 – Deploy to Azure](./dotnet/Challenge-03.md)
- [Challenge 04 – Observe, Validate & Secure](./dotnet/Challenge-04.md)
- [Challenge 05 – Infuse AI (stretch)](./dotnet/Challenge-05.md)

**Java track**
- [Challenge 00 – Prerequisites](./java/Challenge-00.md)
- [Challenge 01 – Assess](./java/Challenge-01.md)
- [Challenge 02 – Java Modernization](./java/Challenge-02.md)
- [Challenge 03 – Deploy to Azure](./java/Challenge-03.md)
- [Challenge 04 – Observe, Validate & Secure](./java/Challenge-04.md)
- [Challenge 05 – Infuse AI (stretch)](./java/Challenge-05.md)
