# Azure Fundamentals for .NET Backends

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

A pragmatic Azure design uses managed services where they reduce operational work without hiding application ownership for security, performance, and recovery.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

The service selection matters less than the complete operating model: identity, network path, deployment, secrets, monitoring, backups, scaling, and cost.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | App Service hosts HTTP workloads with managed platform operations. |
| 2 | Managed identity avoids stored application credentials. |
| 3 | Application Insights correlates requests, dependencies, and failures. |

## Practical Explanation

An order API runs on App Service, authenticates to Azure SQL and Key Vault through managed identity, and emits correlated telemetry.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
builder.Services.AddApplicationInsightsTelemetry();

// DefaultAzureCredential uses managed identity in Azure and developer identity locally.
var credential = new Azure.Identity.DefaultAzureCredential();
```

## Best Practices

- Use managed identity and least privilege.
- Define infrastructure and configuration through repeatable automation.
- Alert on user impact, saturation, and dependency failures.

## Common Mistakes

- Putting secrets in repository configuration.
- Scaling compute before measuring downstream bottlenecks.
- Deploying without health checks or rollback.

## Interview Questions

1. When should you choose App Service over Functions?
2. How does managed identity improve secret handling?
3. What telemetry would you alert on?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [Azure documentation](https://learn.microsoft.com/azure/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
