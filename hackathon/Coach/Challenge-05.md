# Coach Guide – Challenge 05: Observe, Validate & Secure (Stretch)

## Purpose

This stretch challenge is intentionally open-ended. Not all squads will complete it — that is expected. The goal is to expose attendees to production-readiness concerns that go beyond "the app runs". Completing any one of the three areas (observability, secrets, CI/CD) constitutes meaningful progress.

## Mini-Lecture (5 min before challenge)

Cover:
- Why production apps need telemetry: mean-time-to-detect vs. mean-time-to-recover
- Why secrets must never be in code: the attack surface of a leaked connection string
- Why CI/CD matters: the cost of manual deployments at scale

## Application Insights Integration

### Java
Use the **Java in-process agent** (no code changes required — attach the agent JAR):
```dockerfile
# In Dockerfile
ADD https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.x.x/applicationinsights-agent-3.x.x.jar /agent/
ENV JAVA_TOOL_OPTIONS="-javaagent:/agent/applicationinsights-agent-3.x.x.jar"
ENV APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=..."
```

### .NET
Add the NuGet package and configure in `Program.cs`:
```csharp
builder.Services.AddApplicationInsightsTelemetry();
```
Set `ApplicationInsights:ConnectionString` in `appsettings.json` or as an environment variable.

## Key Vault + Managed Identity

Recommended approach for Container Apps:
1. Create an Azure Key Vault
2. Store all connection strings as secrets
3. Assign a User-Assigned Managed Identity to both Container Apps
4. Grant the Managed Identity `Key Vault Secrets User` role on the Key Vault
5. Reference Key Vault secrets directly in the Container App secrets configuration — no SDK changes needed in the application

This approach is the simplest and requires no changes to application code.

## GitHub Actions CI/CD

A minimal workflow for each app should include:
1. Trigger on push to `main`
2. Build the container image
3. Push to Azure Container Registry
4. Run `modernize assess` as a quality gate (fail if critical issues found)
5. Update the Container App revision with the new image

## Common Pitfalls

| Issue | Hint to give |
|---|---|
| App Insights shows no data | Check the connection string is correctly set; also ensure the app has been exercised (send a request) |
| Key Vault access denied | Verify the Managed Identity has the `Key Vault Secrets User` role assignment scoped to the vault |
| `DefaultAzureCredential` fails locally | For local development, use `az login` — `DefaultAzureCredential` will pick up the Azure CLI credential |
| GitHub Actions can't push to ACR | Use the `azure/docker-login` action with a service principal or federated identity credential |

## Success Criteria Notes

- Full completion of all three areas (App Insights + Key Vault + CI/CD) in a half-day event is ambitious — celebrate any meaningful progress
- The Key Vault integration is the highest-value item from a security perspective — prioritise it over CI/CD if time is short
- App Insights latency: it can take 3–5 minutes for data to appear in the portal after first instrumentation
