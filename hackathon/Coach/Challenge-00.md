# Coach Guide – Challenge 00: Prerequisites

## Purpose

This challenge exists to ensure all attendees start from the same baseline. It is largely a logistics/setup challenge and should take no more than 30 minutes.

## Mini-Lecture (5 min before challenge)

Briefly explain:
- The two sample applications (ContosoUniversity and PhotoAlbum-Java) and their legacy stacks
- The overall goal of the hackathon — migrate both apps using AI-powered tools
- The WTH format: challenge-based, no step-by-step instructions, coach-guided

## Common Issues and Hints

### Submodule folders are empty
The most common issue. After cloning, attendees must run:
```bash
git submodule update --init --recursive
```
If they cloned with `--recurse-submodules`, the submodules should be populated automatically.

### Oracle container fails to start (Java app)
Oracle XE requires at least **4 GB RAM** allocated to Docker. Ask attendees to check Docker Desktop → Settings → Resources → Memory. If RAM is insufficient, they can skip the Java local run check and proceed — the assessment and plan steps do not require the Oracle container to be running.

### .NET Framework 4.8 build fails on Linux/macOS
The ContosoUniversity project targets .NET Framework 4.8, which is Windows-only. On Linux/macOS, the build will fail with `msbuild`. This is **expected** — the migration in Challenge 03 will move the project to .NET 9. For this challenge, simply verify that the source code is present (submodule initialised) rather than requiring a successful build on non-Windows machines.

### `modernize` CLI not found after install
The install script adds the binary to `~/.local/bin`. Ensure this path is in `$PATH`:
```bash
echo $PATH | grep local
# If not present:
export PATH="$HOME/.local/bin:$PATH"
```

## Success Criteria Notes

- The Java app local run check can be skipped if Docker memory is insufficient — use judgment
- The .NET build check applies only to Windows machines; on Linux/macOS verify the source is present
- All other checks (gh auth, modernize version, az account) must pass for all attendees
