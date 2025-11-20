Use jj (not git) to look at all the commits from main onwards, see their diffs, and give the commit a good description. Use conventional commit convention. A workflow like the following:

- `JJ_CONFIG= jj log --no-pager -s -r "trunk()..@"`
  - The format is "REVID EMAIL TIME COMMITID"
- For each ref without a description:
  - `jj diff -r REVID`
  - `jj desc -r REVID -m "DESCRIPTION OF CHANGES"`

When taking a look at the content of each commit it may be prudent to split them up into separate commits. If needed offer the user your split plan as it would be in the end result. Use `jj split -r @ -m "MESSAGE" file1 folder2/` to split up the commits easily.
