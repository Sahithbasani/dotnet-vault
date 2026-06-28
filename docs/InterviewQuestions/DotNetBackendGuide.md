# .NET Backend Interview Guide

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

Senior interviews evaluate how an engineer reasons through constraints, failure, maintenance, and trade-offs. Definitions are useful only when connected to production behavior.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

A strong answer makes assumptions explicit, uses a concrete backend example, and explains what would be measured or validated before a decision.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Structure answers as rule, example, trade-off, and failure mode. |
| 2 | Connect C# behavior to runtime, HTTP, database, and operations. |
| 3 | Use modernization stories to show safe change under uncertainty. |

## Practical Explanation

For a slow API question, clarify workload and SLO, trace dependencies, inspect SQL and runtime evidence, propose a reversible change, and define validation.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```text
Question: A .NET API becomes slow only under load. What do you investigate?

Answer outline:
1. Confirm p95/p99 latency, throughput, errors, and saturation.
2. Correlate requests with SQL and downstream dependencies.
3. Inspect thread-pool, connection-pool, allocation, and blocking signals.
4. Reproduce with representative load and validate one change at a time.
```

## Best Practices

- Prepare evidence-based stories about delivery, incidents, refactoring, and disagreement.
- Explain where a recommendation stops being appropriate.
- Say what you would monitor after release.

## Common Mistakes

- Reciting patterns without describing costs.
- Claiming certainty without data.
- Speaking only about implementation and ignoring operations.

## Interview Questions

1. How do scoped services behave in a background worker?
2. How would you modernize a high-risk .NET Framework application?
3. Design an idempotent payment API.

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [.NET documentation](https://learn.microsoft.com/dotnet/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
