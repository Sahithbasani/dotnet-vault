# EF Core Query Performance

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

EF Core performance work starts with SQL shape, row counts, database indexes, and measurement. Concise LINQ is not evidence of an efficient query.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

One N+1 query or unbounded include can exhaust database connections and dominate API latency under ordinary production concurrency.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Projection reduces transferred columns and tracking overhead. |
| 2 | Server-side filtering and pagination bound work. |
| 3 | Query tags and logging connect LINQ to database diagnostics. |

## Practical Explanation

A reporting endpoint pages a stable result set and projects only columns required by the client.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
var page = await dbContext.Orders
    .AsNoTracking()
    .Where(order => order.CreatedAt >= from)
    .OrderByDescending(order => order.CreatedAt)
    .ThenBy(order => order.Id)
    .Select(order => new OrderListItem(order.Id, order.Total, order.Status))
    .Take(100)
    .TagWith("Orders: recent list")
    .ToListAsync(cancellationToken);
```

## Best Practices

- Capture generated SQL and actual execution plans.
- Use bounded queries and deterministic ordering.
- Benchmark with representative data and parameters.

## Common Mistakes

- Calling ToList before filters.
- Issuing a query inside a loop.
- Adding indexes without measuring write cost and actual usage.

## Interview Questions

1. What causes N+1 queries?
2. When would you use a split query?
3. How do you diagnose slow LINQ?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [EF Core documentation](https://learn.microsoft.com/ef/core/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
