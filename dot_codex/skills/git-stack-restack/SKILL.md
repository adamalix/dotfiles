---
name: git-stack-restack
description: Restack a stacked branch and pull request chain onto a new base. Use when the user asks to move a PR stack after a lower PR merged, update the remaining stack onto the latest trunk, fix stack ancestry or PR bases, or rewrite a linear stacked diff series without landing it.
---

# Git Stack Restack

## Overview

Use this skill to rewrite a stacked branch and PR chain onto a new base, then validate and push the updated stack safely. Prefer one deliberate stack rewrite over a series of ad hoc rebases.

## When To Use It

Use this skill when the user asks for any of the following:

- "restack this branch stack"
- "move the remaining PRs onto main"
- "update this stack after the bottom PR merged"
- "fix the PR bases in this stack"
- "rebase the stack onto the latest main"
- "rewrite this stacked diff chain"

Do not use this skill to land the stack in order. That belongs in a separate landing workflow.

## Workflow

Perform this workflow in order.

## 1) Inspect Before Rewriting

Start with `git-stack-inspect` behavior first, even if the user asked directly for a restack.

Identify:

- current branch
- ordered branch chain from bottom to top
- ordered PR chain from bottom to top
- the branch to rewrite at the top of the suffix you need to move
- the branch or commit that currently serves as the old parent of the suffix
- the new base branch or commit

If the stack is not linear, say so and stop unless the user explicitly wants a more complex rewrite.

## 2) Check Safety Preconditions

Before rewriting:

- inspect working tree state with `git status --short`
- inspect worktrees with `git worktree list --porcelain` when using `--update-refs`
- fetch the remote state with `git fetch origin --prune`

Prefer a clean working tree. If the tree is dirty, either:

- stop and ask the user to confirm using `--autostash`, or
- stop and ask the user to clean or stash changes first

Important limitation:

- `git rebase --update-refs` does not update branches that are checked out in another worktree

If a stacked branch is checked out elsewhere, stop and call that out explicitly before rewriting.

## 3) Choose the Rewrite Shape

There are two common rewrite shapes.

### Full-chain restack

Use this when you want to move the entire open stack onto a new external base such as `origin/main`.

Preferred approach:

- rewrite the top branch once with `git rebase --update-refs --onto <new-base> <old-cut-point> <top-branch>`

This lets Git move intermediate branch refs automatically when they point into the rebased range.

### Tail-only restack

Use this when a lower PR has already landed and only the remaining suffix should move.

Again, prefer rewriting the top branch of the remaining suffix once with `--update-refs`, not rebasing each remaining branch separately.

## 4) Pick the Old Cut Point Carefully

This is the highest-risk decision in the workflow.

Use these rules:

- If the old parent is still a true ancestor of the stack, the cut point can often be the old base branch or the fork point below the bottom branch.
- If the parent was merged by squash or rebase, do not assume `git merge-base` with the new trunk is sufficient.
- In squash-merge cases, the safe cut point is usually the old parent branch tip, the old base branch tip, or another explicit commit from the pre-restack graph or reflog.

Do not guess.

If a plain `git rebase <new-base>` or an incorrect cut point starts replaying merged base history, abort and switch to an explicit `--onto` rebase with the correct cut point.

## 5) Rewrite the Stack

Preferred command shape:

```bash
git rebase --update-refs --onto <new-base> <old-cut-point> <top-branch>
```

Guidelines:

- Prefer `origin/main` or another remote-tracking base over a stale local `main`.
- Rewrite the highest branch in the suffix so Git can update intermediate refs with `--update-refs`.
- Do not default to rebasing each branch one by one if a single top-branch rewrite will do the job.
- If the first attempt shows the wrong patch set being replayed, abort immediately with `git rebase --abort` and recompute the cut point.

## 6) Validate Before Pushing

After the rewrite:

- inspect the graph with `git log --oneline --decorate --graph --all --max-count=<enough>`
- inspect branch positions with `git branch -vv`
- compare old and new patch series with `git range-diff`
- inspect PR bases with `gh pr view` or `gh pr list`

Validation goals:

- the chain is still linear
- each branch now sits on the intended new parent
- the rewritten patch series matches the old intent
- no branch was left behind because of a worktree or a missed ref

If `git range-diff` shows unexpected patch loss or duplication, stop and report before pushing.

## 7) Push Safely

When validation is clean, push only the rewritten branches.

Preferred command shape:

```bash
git push --force-with-lease --force-if-includes origin <branch>...
```

Use `--force-with-lease`, not plain `--force`.

Use `--force-if-includes` together with `--force-with-lease` for additional protection when background fetches may have updated remote-tracking refs.

## 8) Repair PR Base Metadata If Needed

After pushing, confirm that the GitHub PR base chain matches the intended stack.

If the new bottom PR in the remaining stack should target trunk, update it with:

```bash
gh pr edit <pr-number> --base <trunk-branch>
```

If intermediate PRs should still point to their parent branch in the stack, verify that they do.

## 9) Report the Result

Return a concise summary with:

- rewritten branches
- new base
- merge order implied by the updated stack
- whether PR bases were changed
- validation status
- any remaining risks

Prefer a compact format like:

- `Restacked`: branches rewritten
- `New base`: target base
- `PR chain`: bottom -> top
- `Validation`: graph and range-diff status
- `Issues`: anything still needing attention

## Constraints

- Prefer a single top-branch `--update-refs` rewrite over many individual rebases.
- Do not use a plain rebase when it will replay already-merged base history.
- Do not push until the graph and patch series both look correct.
- Stop when the old cut point cannot be identified safely.
