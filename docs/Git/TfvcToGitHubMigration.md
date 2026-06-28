# Migrating TFVC/TFS Workflows to GitHub

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

A source-control migration is a workflow and governance change, not only a history conversion. Teams need a clear cutover, branch model, permissions, and CI replacement.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

Legacy applications often depend on undocumented build definitions, service accounts, binaries, and release steps. Discovering those dependencies before cutover prevents a clean Git repository from producing an unusable delivery process.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Inventory repositories, branches, large files, identities, and pipelines. |
| 2 | Choose history depth based on audit and maintenance needs. |
| 3 | Freeze, migrate, validate, and communicate a single cutover point. |

## Practical Explanation

An enterprise .NET application moves from TFVC to GitHub while preserving required history, replacing gated check-ins with protected pull requests, and validating artifact equivalence.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.



## C# / .NET Example

```text
# Validate the migrated repository before cutover
git fsck --full
git log --all --oneline --decorate
git branch --all
git tag --list
```

## Best Practices

- Map identities and permissions deliberately.
- Rebuild CI/CD from documented outcomes, not line-by-line task translation.
- Archive the source system read-only after verification.

## Common Mistakes

- Migrating code but forgetting pipeline variables and release permissions.
- Carrying every obsolete branch indefinitely.
- Allowing commits to both systems after cutover.

## Interview Questions

1. How would you plan a TFVC-to-Git migration?
2. When should full history be retained?
3. How do branch protections replace gated check-ins?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [GitHub documentation](https://docs.github.com/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
