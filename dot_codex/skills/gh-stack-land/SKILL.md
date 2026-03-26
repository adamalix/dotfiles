---
name: gh-stack-land
description: Land a stacked GitHub pull request chain in order. Use when the user asks to merge or land a stack of PRs, finish the remaining PRs after the bottom one goes green, or drive a bottom-up PR landing loop that restacks and updates the remaining branches after each merge.
---

# GH Stack Land

## Overview

Use this skill to land a stacked PR chain from bottom to top using `gh`, restacking the remaining branches after each merge. This skill coordinates inspection, CI watching, merge execution, and restacks between merges until the stack is empty or blocked.

## When To Use It

Use this skill when the user asks for any of the following:

- "land this PR stack"
- "merge these stacked PRs in order"
- "finish landing the remaining PRs"
- "wait for the bottom PR and then merge the rest"
- "drive this stack to main"

Do not use this skill for a pure restack without merges. That belongs in `git-stack-restack`.

## Workflow

Perform this workflow in order.

## 1) Inspect the Stack First

Start with `git-stack-inspect` behavior first, even if the user asked directly to land the stack.

Identify:

- ordered PR chain from bottom to top
- current bottom PR that must merge next
- current top PR
- branch chain behind the PR stack
- whether the stack is linear and mergeable in sequence

If the stack is inconsistent or not linear, stop and report before merging anything.

## 2) Check the Bottom PR State

For the PR at the bottom of the remaining stack, inspect at least:

```bash
gh pr view <pr-number> --json number,title,state,isDraft,baseRefName,headRefName,url,mergeStateStatus,reviewDecision,statusCheckRollup
```

Do not merge a higher PR while a lower PR is still open.

Confirm:

- PR is open
- PR is not draft
- required reviews are satisfied, if applicable
- status checks are green or actively progressing toward green
- there is no merge conflict or other merge blocker

If the bottom PR is blocked, stop and report the blocker instead of skipping ahead.

## 3) Watch or Repair CI Only as Needed

If the bottom PR is still running or queued:

- prefer watching the exact run you need
- use `gh run watch <run-id>` when you have the run ID
- otherwise inspect run state with `gh run list --limit 20 --json databaseId,headBranch,status,conclusion,workflowName,event,createdAt,updatedAt`

Use CI intervention sparingly.

Safe interventions:

- cancel a redundant or superseded run on the same branch
- cancel an irrelevant `main` or upper-stack run only when it is clearly blocking the bottom PR from getting the runner lane
- rerun the exact bottom PR run if it was canceled or appears stuck in queue

Risk controls:

- say what run you are canceling and why
- prefer freeing the lane for the next mergeable bottom PR only
- do not broadly cancel unrelated workflows

## 4) Merge the Bottom PR

Once the bottom PR is actually mergeable, merge it with `gh pr merge`.

Always squash merge stacked PRs with this skill.

Required command shape:

```bash
gh pr merge <pr-number> --squash
```

After merging, verify that the PR is merged with:

```bash
gh pr view <pr-number> --json state,mergedAt,mergeCommit,url
```

## 5) Refresh Trunk and Restack the Remainder

After each successful merge:

- fetch the updated remote state
- determine the new remaining stack
- restack the remaining suffix with `git-stack-restack` behavior

If the new bottom PR in the remaining stack should now target trunk, update its base with:

```bash
gh pr edit <pr-number> --base <trunk-branch>
```

Then validate that the remaining open PR chain is still correct before continuing.

## 6) Repeat Bottom-Up

Repeat the loop:

1. inspect remaining stack
2. identify the next bottom PR
3. wait, repair CI if needed, and merge it
4. restack the remainder

Continue until:

- no open PRs remain in the stack, or
- the next bottom PR is blocked and requires user input or a separate fix

## 7) Report Progress Clearly

After each merge, report:

- which PR merged
- merge commit, if available
- what was restacked
- what PR is now at the bottom
- whether CI intervention was needed

At the end, report:

- merge order
- final state of the stack
- whether any PRs remain open
- any notable operational issues such as CI lane contention

## Constraints

- Always merge from bottom to top.
- Always squash merge with `gh pr merge --squash`.
- Never skip a blocked lower PR and merge above it.
- Use `gh` for GitHub state and merge operations.
- Keep CI cancellations narrow and justified.
- Restack and validate the remaining chain after every merge, not just at the end.
- Stop when the next merge is not safe or the remaining stack is not well understood.
