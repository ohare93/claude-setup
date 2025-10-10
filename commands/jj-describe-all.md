Use jj (not git) to look at all the commits from main onwards, see their diffs, and give the commit a good description. Use conventional commit convention. A workflow like the following:

- `JJ_CONFIG= jj log --no-pager -s -r "trunk()..@"`
  - The format is "REVID EMAIL TIME COMMITID"
- For each ref without a description:
  - `jj diff -r REVID`
  - `jj desc -r REVID -m "DESCRIPTION OF CHANGES"`
