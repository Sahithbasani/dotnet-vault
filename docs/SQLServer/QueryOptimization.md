# SQL Server Query Optimization

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

Query optimization is evidence-driven: identify the slow workload, capture duration and logical reads, inspect the actual plan, then change one constraint at a time.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

Production databases carry skewed data, concurrent writes, and varied parameters. A query that is fast against a developer database can fail at enterprise scale.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Cardinality estimates influence join and access choices. |
| 2 | Indexes trade read efficiency for writes and storage. |
| 3 | Waits and blocking distinguish query cost from concurrency delay. |

## Practical Explanation

An order-history query is tuned using representative customer sizes, statistics I/O, Query Store, and its actual execution plan.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```sql
SET STATISTICS IO, TIME ON;

SELECT OrderId, CreatedAt, Total
FROM Sales.Orders
WHERE CustomerId = @CustomerId
  AND CreatedAt >= @FromDate
ORDER BY CreatedAt DESC;
```

## Best Practices

- Establish a baseline and rollback plan.
- Compare estimated and actual rows.
- Design indexes around predicates, ordering, and returned columns.

## Common Mistakes

- Using NOLOCK as a performance fix.
- Reading only graphical operator percentages.
- Testing one convenient parameter against a tiny data set.

## Interview Questions

1. Why can an index seek still be slow?
2. What does a large estimate error suggest?
3. How would you investigate blocking?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [SQL Server documentation](https://learn.microsoft.com/sql/sql-server/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
