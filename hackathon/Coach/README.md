# Coach Guide – What The Hack: GitHub Copilot App Modernization

> ⚠️ **Do NOT share this folder with attendees during the event.** Content here contains solutions, hints, and coaching notes.

## Overview

This hack is designed for squads of 3–5 people. It covers two parallel modernization tracks:

| Track | Application | Legacy Stack | Target Stack |
|---|---|---|---|
| Java | PhotoAlbum | Spring Boot 2.7 / Java 8 / Oracle DB | Spring Boot 3.x / Java 21 / PostgreSQL + Azure Blob |
| .NET | ContosoUniversity | .NET Framework 4.8 / ASP.NET MVC 5 / MSMQ | .NET 9 / ASP.NET Core / Azure Service Bus + Blob |

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
| 11:15 – 13:00 | Challenges 02 & 03 (parallel) |
| 13:00 – 14:00 | Lunch break |
| 14:00 – 15:30 | Continue Challenges 02 & 03 |
| 15:30 – 16:30 | Challenge 04 — Deploy to Azure |
| 16:30 – 17:00 | Challenge 05 (stretch) |
| 17:00 – 17:30 | Wrap-up, retrospective, demo |

### Squad Size

- **Ideal:** 3–5 people
- **Minimum:** 2 people (one per track in Challenges 02/03)
- **Maximum:** 5 people (assign roles: Java lead, .NET lead, infra lead, tester, documentarian)

## Coach Responsibilities

- **Do not give answers** — give hints and ask questions that help the squad discover the solution
- Deliver a short (5–10 minute) mini-lecture before Challenges 01, 02/03, and 04 to set context
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

See individual coach files:
- [Challenge 00 – Prerequisites](./Challenge-00.md)
- [Challenge 01 – Assess](./Challenge-01.md)
- [Challenge 02 – Java Modernization](./Challenge-02.md)
- [Challenge 03 – .NET Modernization](./Challenge-03.md)
- [Challenge 04 – Deploy to Azure](./Challenge-04.md)
- [Challenge 05 – Observe, Validate & Secure](./Challenge-05.md)
