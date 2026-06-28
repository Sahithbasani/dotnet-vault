# Diagnosing .NET Backend Performance

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

Performance engineering starts with a user-visible symptom and follows evidence through application, runtime, database, and downstream dependencies.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

Guessing produces fragile micro-optimizations. Production capacity is usually shaped by latency, allocation, thread-pool pressure, connection pools, query cost, and external calls.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Measure latency distributions rather than averages. |
| 2 | Async I/O improves concurrency but does not make dependencies faster. |
| 3 | Caching requires ownership of freshness, size, and failure behavior. |

## Practical Explanation

A slow orders endpoint is traced from request telemetry to an EF query, database reads, and a repeated downstream call before any code is changed.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
using var activity = activitySource.StartActivity("LoadOrder");
var stopwatch = Stopwatch.StartNew();
var order = await repository.GetAsync(orderId, cancellationToken);
logger.LogInformation("Loaded order {OrderId} in {ElapsedMs} ms", orderId, stopwatch.ElapsedMilliseconds);
```

## Best Practices

- Define an SLO and baseline first.
- Profile representative load and inspect p95/p99 latency.
- Change one bottleneck and verify the effect.

## Common Mistakes

- Optimizing allocations while a database call dominates latency.
- Adding unbounded caches.
- Using Task.Run to disguise blocking server code.

## Interview Questions

1. How do you diagnose high p99 latency?
2. When does async improve throughput?
3. What makes a cache safe in a multi-instance service?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [.NET documentation](https://learn.microsoft.com/dotnet/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
