# SOLID in Enterprise .NET Code

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

SOLID is useful as a design review vocabulary when it reduces change cost. It is not a requirement to create an interface, layer, or class for every operation.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

Enterprise code changes for years. Cohesive responsibilities and dependencies on stable contracts let teams replace infrastructure without rewriting policy.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Single responsibility means one coherent reason to change. |
| 2 | Substitution requires implementations to preserve contract behavior. |
| 3 | Dependency inversion places abstractions near the policy that consumes them. |

## Practical Explanation

A checkout use case owns an IPaymentGateway contract while infrastructure adapts the external payment provider.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
public interface IPaymentGateway
{
    Task<PaymentResult> ChargeAsync(
        PaymentRequest request,
        CancellationToken cancellationToken);
}
```

## Best Practices

- Apply principles where change pressure exists.
- Keep interfaces consumer-focused.
- Use composition before inheritance.

## Common Mistakes

- Creating abstractions with only one speculative purpose.
- Moving all code into tiny classes with no cohesion.
- Treating dependency injection as proof of dependency inversion.

## Interview Questions

1. How can SRP be applied without creating tiny classes?
2. What is a substitution violation?
3. Where should an interface live?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [.NET architecture guides](https://learn.microsoft.com/dotnet/architecture/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
