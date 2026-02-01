# Interacting with GitHub

Use the `gh` command to interact with GitHub whenever possible.

<examples>
- "let's work on issue 1160" -> look the issue up using `gh issue view 1160`
- "create a pull request for issue 1160" -> create a PR using `gh pr create --issue 1160`
- "what's the status of issue 1160?" -> check the issue status using `gh issue view 1160`
- "assign me to issue 1160" -> assign yourself using `gh issue edit 1160 --add-assignee @me`
- "implement the fixes proposed in the comments on pull request 1727" --> check the comments use `gh pr view 1727 --comments`
</examples>

# Working

Whenever possible, end-to-end verify changes that you make. For example, run tests to verify changed behavior and then fix any failing tests. Build after code changes to be sure they compile and fix any new warnings or compile errors. If you cannot verify a change, state what blocks you.

# Skills

For skills that need a dependency, use `uv` to run python with a dependency.

Example: `uv run --with pyyaml python <script.py>`

# Newlines

When creating github comments, commit messages, etc do not use `\n` for newlines.
