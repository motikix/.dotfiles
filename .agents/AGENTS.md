## Version control

- At the start of work in a repository, run `jj root`.
- If `jj root` exits with status 0, use `jj` for all subsequent version-control operations. Otherwise, use `git`.

## Code review

- When asked to perform a code review, use the `herdr` skill to open a new pane in the current tab.
- Before starting the review, run `hunk show` in the newly created pane to launch a Hunk session.
- Post review findings to that Hunk session using the `hunk-review` skill.
- Write Hunk comments and the final review response in the language used in the user's review request, unless the user specifies another language.
- If Herdr is unavailable or the Hunk session cannot be launched, report that limitation and ask the user how to proceed.

@RTK.md
