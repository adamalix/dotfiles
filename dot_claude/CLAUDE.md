# Global Claude Configuration

## GitHub Integration

### Interacting with GitHub

Use the `gh` command to interact with GitHub whenever possible.

<examples>
  "let's work on issue 1160" -> look the issue up using `gh issue view 1160`
  "create a pull request for issue 1160" -> create a PR using `gh pr create --issue 1160`
  "what's the status of issue 1160?" -> check the issue status using `gh issue view 1160`
  "assign me to issue 1160" -> assign yourself using `gh issue edit 1160 --add-assignee @me`
</examples>

### Authoring Issues and Pull Requests

When writing issues or pull requests, consider the following:

- Enclose non-user references with backticks to avoid mentioning users or teams.
<example>
  When authoring a pull request about doing a migration to the `@Observable` framework, you might say:
  "Migrating to the `@Observable` framework"
</example>

- When authoring pull requests, use the template in `.github/PULL_REQUEST_TEMPLATE.md`
- Reference issues this is working towards by saying `Ref #<issue_number>` in the PR description
- Close issues completed by saying `Closes #<issue_number>` in the PR description
