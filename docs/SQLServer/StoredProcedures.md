# SQL Server Stored Procedures in Backend Systems

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

Stored procedures remain common in enterprise systems for stable database operations, permission boundaries, reporting, and legacy integration.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

They become maintainable when inputs, result shapes, transactions, and errors are treated as a versioned contract rather than hidden database behavior.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Parameters protect values and support plan reuse. |
| 2 | SET XACT_ABORT and TRY/CATCH clarify transaction failure. |
| 3 | Result sets should have documented stable columns. |

## Practical Explanation

A service retrieves a bounded order summary through a procedure while application code retains orchestration and business policy.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```sql
CREATE PROCEDURE Sales.GetOrderSummary
    @OrderId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT OrderId, CustomerId, Status, Total
    FROM Sales.Orders
    WHERE OrderId = @OrderId;
END;
```

## Best Practices

- Schema-qualify objects and use explicit column lists.
- Review procedure changes with application contract changes.
- Grant execute permission instead of broad table access when appropriate.

## Common Mistakes

- Concatenating dynamic SQL.
- Returning multiple undocumented result shapes.
- Starting transactions without a reliable rollback path.

## Interview Questions

1. When should logic remain in SQL versus application code?
2. How do parameter-sensitive plans affect procedures?
3. Why use SET NOCOUNT ON?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [SQL Server documentation](https://learn.microsoft.com/sql/sql-server/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
