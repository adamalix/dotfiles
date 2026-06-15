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

## Quality

Ensure changes adhere to repository quality checks. For example, fix any new compiler, linter or typechecker warnings. Use the tools in each repository to ensure local quality checks pass.

# Skills

Prefer running skills with `uv`

Example: `uv run <script.py>`

# Newlines

When creating github comments, commit messages, etc do not use `\n`. Prefer flags or bodyfiles to separate paragraphs.

Examples:

- For commit messages, use `git commit -m "Subject line" -m "Paragraph 1" -m "Paragraph 2"`
- When using `gh`, use the `--body-file` flag.

# Subagents

When using subagents, wait for them to return. Do no duplicate or do their work in parallel as they execute.

# Tools

Always use elevated permissions When using `gog` or `asc` CLI tools, asthey require access to the macOS keychain.
