# Curated .NET Engineering Resources

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

A senior learning library favors primary documentation, specifications, maintainers, and material that can be tested against real systems.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

Fast-moving platform guidance becomes stale. Recording why a source is trusted and when a decision was verified is more useful than collecting large link lists.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Primary sources establish product behavior. |
| 2 | Architecture material should include context and trade-offs. |
| 3 | Learning should produce an experiment, decision record, or code-review improvement. |

## Practical Explanation

For each subject, begin with Microsoft documentation, reproduce the behavior, inspect source or specifications when needed, and write the operational takeaway.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```text
Resource note
- Question: What decision am I trying to make?
- Primary source: official documentation or specification
- Experiment: smallest reproducible validation
- Takeaway: rule, boundary, and version checked
- Review date: when this note should be revisited
```

## Best Practices

- Prefer Microsoft Learn, .NET source, language specifications, and established engineering books.
- Keep a review date for Azure and framework guidance.
- Capture conclusions rather than copying source text.

## Common Mistakes

- Treating conference opinion as product contract.
- Saving links without context.
- Repeating old framework guidance in modern .NET services.

## Interview Questions

1. How do you validate a version-sensitive claim?
2. What makes an engineering source authoritative?
3. How do you turn reading into applied learning?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [.NET documentation](https://learn.microsoft.com/dotnet/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
