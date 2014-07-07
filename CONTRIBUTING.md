# How to Contribute

## UCSD Library Development Team
For small changes, UCSD developers can work on the develop branch directly. If a significant update is needed, or a new feature is being developed, please use the following process for creating a new [Pull Request](https://help.github.com/articles/using-pull-requests "Pull Request").

1. Create a feature branch for new work.
2. Push commits to the feature branch, with appropriate test coverage (and tests passing).
3. Prior to creating a Pull Request, pull from the remote 'develop' branch to make sure your feature branch is up to date. Fix any merge conflicts and make sure all tests still pass.
4. Create a pull request by going to the branch in github (e.g. https://github.com/ucsdlib/damspas/tree/branchname/) and clicking on the pull request button (green arrows going in a circle). Make sure the PR can be merged automatically, if it can't go back to Step 3.
5. Give the pull request a short meaningful title, and put a link to the relevant JIRA ticket or other issue in the description.
6. Add a link to the pull request in the JIRA ticket.
7. Choose the __Request Code Review__ transition in the JIRA ticket.
8. Development Manager will assign a developer to review the pull request.

## Merging Changes from Pull Requests

* Please take the time to review the changes and get a sense of what is being changed. Things to consider:
  * Does the commit message explain what is going on?
  * Does the code changes have tests? _Not all changes need new tests, some changes are refactorings_
  * Does the commit contain more than it should? Are two separate concerns being addressed in one commit?
  * Does the new code follow Ruby and Rails style guides? Run RuboCop on the new/updated files and report any "offenses" in JIRA.
* Do all tests pass successfully? You can review a feature branch by using the dams_private damspas.sh as follows:  
` cd private_config `  
` ./damspas.sh name-of-feature feature/name-of-feature test `  
` cd name-of-feature `  
` bundle exec rspec `  
* If you are uncertain, bring other contributors into the conversation by creating a comment that includes their @username.
* If you like the pull request, but want others to chime in, create a +1 comment and tag a user.
* If the Pull Request is approved and merged, choose the __Approve Pull Request__ transition in the JIRA ticket and assign back to original developer.
* If the Pull Request is rejected, choose the __Reject Pull Request__ transition in the JIRA ticket and assign back to original developer.