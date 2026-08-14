## Version control

- At the start of work in a repository, run `jj root`.
- If `jj root` exits with status 0, use `jj` for all subsequent version-control operations. Otherwise, use `git`.

## Code review

- When asked to perform a code review, use the `herdr` skill to open a new pane in the current tab.
- Post review findings to the active Hunk session using the `hunk-review` skill.
- If Herdr or an active Hunk session is unavailable, report that limitation and ask the user how to proceed.
