# Production REST API Design

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

A production REST API is a durable contract, not a thin projection of database tables. Resource modeling, status codes, validation, idempotency, and versioning determine how safely clients evolve.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

Backend services are changed by multiple teams on different schedules. Explicit contracts prevent internal refactors from becoming client outages.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Resources use stable identifiers and HTTP semantics. |
| 2 | Problem Details gives failures a consistent machine-readable shape. |
| 3 | Idempotency protects retried commands from duplicate side effects. |

## Practical Explanation

A payment endpoint accepts an idempotency key, validates the command, and returns an accepted operation rather than holding the request open for downstream settlement.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
[HttpPost("payments")]
public async Task<ActionResult<PaymentAccepted>> Create(
    CreatePaymentRequest request,
    [FromHeader(Name = "Idempotency-Key")] string key,
    CancellationToken cancellationToken)
{
    var result = await service.CreateAsync(request, key, cancellationToken);
    return AcceptedAtAction(nameof(Get), new { id = result.PaymentId }, result);
}
```

## Best Practices

- Use request and response DTOs separate from persistence entities.
- Document success and failure responses in OpenAPI.
- Paginate collections and cap caller-controlled limits.

## Common Mistakes

- Returning 200 for every outcome.
- Breaking clients by renaming serialized fields casually.
- Retrying non-idempotent operations without a deduplication strategy.

## Interview Questions

1. When is 202 more appropriate than 201?
2. How would you version a public API?
3. How do you make payment creation idempotent?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [ASP.NET Core documentation](https://learn.microsoft.com/aspnet/core/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
