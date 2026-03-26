---
name: git-stack-inspect
description: Inspect a stacked branch and pull request chain without modifying it. Use when the user asks what branches or PRs are in a stack, what the merge order is, which PR is at the bottom or top, whether PR bases are correct, or how a current branch relates to the rest of a stacked diff series.
---

# Git Stack Inspect

## Overview

Use this skill to discover and explain the current Git stack from local branches and GitHub PR metadata. This is a read-only skill: inspect, validate, summarize, and surface inconsistencies, but do not rebase, retarget PRs, push, or merge.

## When To Use It

Use this skill when the user asks for any of the following:

- "inspect this stack"
- "what PRs are in this stack?"
- "what is the merge order?"
- "which PR is at the bottom?"
- "is this branch stacked on another branch?"
- "are the PR bases correct?"
- "how does my current branch relate to the rest of the chain?"

Prefer this skill before any restack or landing workflow so you have a verified view of the stack first.

## Workflow

Perform this workflow in order.

## 1) Gather local Git context

- Detect the current branch with `git branch --show-current`.
- Inspect local branch tracking state with `git branch -vv`.
- Inspect the visible graph with `git log --oneline --decorate --graph --all --max-count=<enough to cover the stack>`.
- If worktrees may matter, inspect them with `git worktree list --porcelain`.

Keep this step read-only. Do not switch branches or modify refs.

## 2) Gather GitHub PR context

Prefer `gh` for GitHub state.

- If the user named a specific PR, inspect it with `gh pr view <number> --json number,title,state,isDraft,baseRefName,headRefName,url`.
- Otherwise, list candidate PRs with `gh pr list --state open --limit 200 --json number,title,headRefName,baseRefName,isDraft,url`.
- Build a map from `headRefName -> PR`.
- A likely stack is a chain where each PR base is either:
  - `main` or another stable trunk branch, or
  - the `headRefName` of another PR in the same open set.

When the repo uses stacked PRs, GitHub base metadata is the primary source for intended stack shape.

If `gh` is unavailable or unauthenticated, say that the result is local-only and lower confidence.

## 3) Infer the stack

Infer the ordered chain using both sources:

- Intended order from PR `baseRefName -> headRefName`
- Actual order from Git ancestry

Use local ancestry checks when needed:

- `git merge-base --is-ancestor <base-branch> <head-branch>`
- `git rev-parse <branch>`

Use the current branch as the default anchor when the user did not name a specific PR or branch.

If the current branch belongs to a larger stack, identify:

- current branch
- current PR, if any
- bottom branch/PR
- top branch/PR
- complete branch chain
- complete PR chain
- expected merge order from bottom to top

If there is no clear stack, say so explicitly instead of forcing one.

## 4) Validate consistency

Check for these common problems:

- PR base does not match the intended parent branch
- local branch ancestry does not match PR base relationships
- a branch in the PR chain is missing locally
- current branch is not part of the open PR stack
- local `main` is behind `origin/main`
- one of the stacked branches is checked out in another worktree
- the chain forks instead of staying linear

When GitHub and local Git disagree, say which source says what. Do not silently choose one.

## 5) Report the result

Return a concise inspection summary with:

- current branch
- current PR, if any
- stack status: linear, inconsistent, partial, or no stack found
- ordered merge sequence
- bottom and top of stack
- branch-to-PR mapping
- any inconsistencies or risks

Prefer a compact format like:

- `Current`: branch and PR
- `Chain`: bottom -> top
- `Merge order`: PR numbers in landing order
- `Issues`: mismatched bases, missing branches, stale local refs, worktree blockers

## Constraints

- This skill is inspection-only.
- Do not run `git rebase`, `git push`, `gh pr edit`, `gh pr merge`, or any other mutating command.
- If the user asks to change the stack after inspection, finish the inspection first, then hand off to a stack-restack or stack-land workflow.
