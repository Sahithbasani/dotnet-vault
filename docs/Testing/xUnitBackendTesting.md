# xUnit Testing for Backend Services

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

Backend tests should protect business behavior and integration boundaries without coupling the suite to private implementation details.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

When modernizing older code, characterization tests create room to refactor. For new work, focused unit tests and realistic integration tests provide different kinds of confidence.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Facts test one invariant; theories test meaningful data variations. |
| 2 | Unit tests isolate policy, not every class. |
| 3 | Integration tests verify HTTP, persistence, serialization, and configuration wiring. |

## Practical Explanation

A payment policy rejects duplicate settlement while integration coverage verifies the API maps that outcome to the correct Problem Details response.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```csharp
[Theory]
[InlineData(PaymentStatus.Settled)]
[InlineData(PaymentStatus.Reversed)]
public void CanSettle_returns_false_for_terminal_statuses(PaymentStatus status)
{
    var payment = Payment.WithStatus(status);

    Assert.False(payment.CanSettle());
}
```

## Best Practices

- Name tests by behavior and expected outcome.
- Keep test data intentional and deterministic.
- Run database integration tests against an isolated disposable database.

## Common Mistakes

- Mocking DbSet and believing SQL translation was tested.
- Asserting every collaborator call.
- Sharing mutable fixtures between parallel tests.

## Interview Questions

1. What belongs in a unit test versus integration test?
2. How do characterization tests support modernization?
3. When should a dependency be mocked?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [.NET testing documentation](https://learn.microsoft.com/dotnet/core/testing/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
