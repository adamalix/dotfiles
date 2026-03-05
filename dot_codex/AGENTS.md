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

## Verification

It is imperative to verify that changes are correct and functional. For example, run tests to verify changed behavior and then fix any failing tests. Build after code changes to be sure they compile. If you cannot verify a change, state what blocks you.

## Quality

Ensure changes are of high quality. For example, fix any new compiler, linter or typechecker warnings. Use the tools in each repository to ensure local quality checks pass.

Simpler and idiomatic solutions are best. Ask yourself if the solution you're thinking about is the simplest approach to a given problem.

Work from first principles and apply systems-level fixes. Do not apply band-aid fixes; instead find root causes to keep quality high.

# Skills

Prefer running skills with `uv`

Example: `uv run <script.py>`

# Newlines

When creating github comments, commit messages, etc do not use `\n`. Prefer flags or bodyfiles to separate paragraphs.

Examples:

- For commit messages, use `git commit -m "Subject line" -m "Paragraph 1" -m "Paragraph 2"`
- When using `gh`, use the `--body-file` flag.
