---
description: Reviews uncommitted changes, summarizes them, and warns of potential issues before commit.
---

# Review Changes

Check the current uncommitted changes in the repository and prepare an overview for a code review.

## Steps

1. Display the list of changed files: `git status --short`
2. Display the diff of changed files: `git diff`
3. Check whether the changes:
   - Do not contain debug outputs, `print()`, or `_logger.debug()` calls intended only for development
   - Do not contain commented-out code (prefer deleting over commenting out)
   - Do not contain sensitive data (passwords, API keys, tokens)
   - Are consistent with the project conventions from `AGENTS.md`
4. Summarize the changes briefly: what was changed and why
5. If there are issues, list them; otherwise, confirm that the changes look fine
