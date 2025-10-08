# Interacting with GitHub

Use the `gh` command to interact with GitHub whenever possible.

<examples>
  "let's work on issue 1160" -> look the issue up using `gh issue view 1160`
  "create a pull request for issue 1160" -> create a PR using `gh pr create --issue 1160`
  "what's the status of issue 1160?" -> check the issue status using `gh issue view 1160`
  "assign me to issue 1160" -> assign yourself using `gh issue edit 1160 --add-assignee @me`
</examples>
