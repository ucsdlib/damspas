# How to Contribute

## UCSD Library Development Team
For small changes, UCSD developers can work on the develop branch directly. If a significant update is needed, or a new feature is being developed, please use the following process for creating a new [Pull Request](https://help.github.com/articles/using-pull-requests "Pull Request").

1. Create a feature branch for new work.
2. Push commits to the feature branch, with appropriate test coverage (and tests passing).
3. Prior to creating a Pull Request, pull from the remote 'develop' branch to make sure your feature branch is up to date. Fix any merge conflicts and make sure all tests still pass.
4. Create a pull request by going to the branch in github (e.g. https://github.com/ucsdlib/damspas/tree/branchname/) and clicking on the pull request button (green arrows going in a circle). Make sure the PR can be merged automatically, if it can't go back to Step 3.
5. Give the pull request a short meaningful title, and put a link to the relevant JIRA ticket or other issue in the description.
6. Add a link to the pull request in the JIRA ticket.
7. Another developer will be asked to review the pull request and assigned responsibility for merging into the develop branch

## Merging Changes from Pull Requests

* It is considered "poor form" to merge your own request.
* Please take the time to review the changes and get a sense of what is being changed. Things to consider:
  * Does the commit message explain what is going on?
  * Does the code changes have tests? _Not all changes need new tests, some changes are refactorings_
  * Does the commit contain more than it should? Are two separate concerns being addressed in one commit?
  * Do all the tests complete successfully?
* If you are uncertain, bring other contributors into the conversation by creating a comment that includes their @username.
* If you like the pull request, but want others to chime in, create a +1 comment and tag a user.
* If the pull request is merged or rejected, make an appropriate status comment in the JIRA ticket