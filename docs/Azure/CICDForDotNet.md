# CI/CD for .NET Applications

[← Documentation index](../README.md) · [Repository home](../../README.md)

## Overview

A reliable pipeline produces one tested artifact and promotes that same artifact through environments with controlled configuration.

> [!NOTE]
> This guidance is intentionally practical. Confirm version-sensitive behavior against current primary documentation.

## Why It Matters in Real Projects

CI/CD is a production safety mechanism. It should make quality, security, approvals, deployment state, and rollback visible rather than automate an opaque script.

## Core Concepts

| # | Engineering principle |
| ---: | --- |
| 1 | Continuous integration validates every proposed change. |
| 2 | Immutable artifacts prevent environment-specific rebuild drift. |
| 3 | Deployment stages add approvals, health verification, and rollback. |

## Practical Explanation

A GitHub or Azure DevOps pipeline restores deterministically, builds, tests, publishes an artifact, deploys to staging, verifies health, and promotes.

## Enterprise / Backend Use Case

In a production service, I would define the boundary first, make ownership visible, add telemetry around the failure modes, and introduce the change in a reversible slice. The specific design should follow workload, data sensitivity, deployment constraints, and the maintenance cost for the team that owns it.

## Production Considerations

- Define expected failure behavior, timeout or transaction boundaries, and recovery.
- Make logs and traces useful without recording credentials or sensitive business data.
- Verify the design with representative concurrency and data volume.

```mermaid
flowchart LR
    Commit --> Restore --> Build --> Test
    Test --> Artifact["Versioned artifact"]
    Artifact --> Staging
    Staging --> Verify["Smoke + health checks"]
    Verify --> Approval
    Approval --> Production
    Production --> Observe["Telemetry + rollback"]
```

## C# / .NET Example

```yaml
- name: Build and test
  run: |
    dotnet restore --locked-mode
    dotnet build --no-restore --configuration Release
    dotnet test --no-build --configuration Release
    dotnet publish src/OrderApi --no-build --configuration Release --output publish
```

## Best Practices

- Pin SDK and action/task versions intentionally.
- Separate build from deployment.
- Make database changes backward compatible across rolling releases.

## Common Mistakes

- Rebuilding for each environment.
- Embedding secrets in YAML.
- Treating a successful deployment command as successful service health.

## Interview Questions

1. Why promote one artifact?
2. How do you deploy a breaking schema change safely?
3. What makes rollback reliable?

<details>
<summary>How to answer well</summary>

State the governing rule, use a concrete backend example, explain the main trade-off, and describe how you would verify the decision in production.

</details>

## References

- [Azure documentation](https://learn.microsoft.com/azure/)
- [Microsoft .NET application architecture guidance](https://learn.microsoft.com/dotnet/architecture/)
