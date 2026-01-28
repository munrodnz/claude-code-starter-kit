### Prerequisites

To maximize the functionality of the Claude Code Starter Kit, ensure the following tools and dependencies are installed:

- **Beads by Steve Yegge** (Required): Beads streamlines development workflows and provides additional context for hooks. Install using [Beads GitHub repository](https://github.com/yourusername/beads) and follow the setup instructions.

- **Convex** (Optional): For Convex projects, Convex hooks are included. Install Convex at [Convex](https://docs.convex.dev/).

### Good Practices

Follow these best practices to keep your automation and workflow streamlined:

1. Maintain high **test coverage**:
   - Aim for over 90% coverage on critical business logic.
   - Write tests for new functionality and update tests when fixing bugs.

2. Use **Sequential Deployments**:
   - For large-scale projects, deploy changes incrementally and verify after each stage.

3. **Code Reviews**:
   - Leverage tools such as pull request templates to ensure code consistency.
   - Keep PRs small and atomic (focusing on a single task or improvement).

4. Periodic **Hook Maintenance**:
   - Update hooks through the `update.sh` script.
   - Review hook output logs to ensure components like ESLint and TypeScript keep running error-free.