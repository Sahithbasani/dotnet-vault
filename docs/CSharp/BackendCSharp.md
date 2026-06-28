# C# for Maintainable Backend Services

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

C# language features are most valuable when they make service behavior explicit: nullable contracts, immutable data, controlled state, and asynchronous I/O.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

In enterprise backends, small ambiguity compounds across APIs, jobs, and database boundaries. Clear types reduce defensive checks and make refactoring older code safer.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Nullable reference types expose missing-value decisions at compile time. |
| 2 | Records are useful for immutable messages and value-oriented contracts. |
| 3 | Cancellation and async composition protect request capacity under load. |

## Practical Explanation

An order endpoint receives an external request, converts it to an immutable command, and passes cancellation through every I/O boundary.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
public sealed record PlaceOrderCommand(Guid CustomerId, IReadOnlyList<OrderLine> Lines);

public sealed class OrderService(IOrderRepository repository)
{
    public async Task<Guid> PlaceAsync(PlaceOrderCommand command, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        var order = Order.Create(command.CustomerId, command.Lines);
        await repository.AddAsync(order, cancellationToken);
        return order.Id;
    }
}
```

## Best Practices

- Enable nullable reference types and treat warnings as design feedback.
- Prefer domain-specific types and immutable request models.
- Keep asynchronous code asynchronous from controller to database.

## Common Mistakes

- Using null-forgiving operators to silence uncertain contracts.
- Returning mutable persistence entities from public APIs.
- Blocking asynchronous work with .Result or .Wait().

## Interview Questions

1. When would you choose a record over a class?
2. How does cancellation propagate through an ASP.NET Core request?
3. What makes a value object safe to use as a dictionary key?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [C# documentation](https://learn.microsoft.com/dotnet/csharp/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
