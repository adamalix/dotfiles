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

- End-to-end verify changes. If you cannot, state what blocks you.

# Skills

For skills that need a dependency, use `uv` to run python with a dependency.

Example: `uv run --with pyyaml python <script.py>`

# Newlines

When creating github comments, commit messages, etc, use actual newlines. Do not use `\n` for newlines.
