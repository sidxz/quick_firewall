# Contributor Guideline

This document provides an overview of how you can participat in improving this project or extending it. We are grateful for all your help: bug reports and fixes, code contributions, documentation or ideas. Feel free to join, we appreciate your support!!

## Communication

### GitHub repositories

Much of the issues, goals and ideas are tracked in the respective projects in GitHub. Please use this channel to report bugs and post ideas.

## git and GitHub

In order to contribute code please:

1. Fork the project on GitHub
2. Clone the project
3. Add changes (and tests)
4. Commit and push
5. Create a merge-request

To have your code merged, see the expectations listed below.

You can find a well-written guide [here](https://help.github.com/articles/fork-a-repo).

Please follow common commit best-practices. Be explicit, have a short summary, a well-written description and references. This is especially important for the merge-request.

Some great guidelines can be found [here](https://wiki.openstack.org/wiki/GitCommitMessages) and [here](http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message).


## Expectations

### Be explicit

* Please avoid using nonsensical property and variable names
* Use self-describing attribute names for user configuration
* In case of failures, communicate what happened and why a failure occurs to the user. Make it easy to track the code or action that produced the error. Try to catch and handle errors if possible to provide improved failure messages.


### Add tests

The security review of this project is done using integration tests.

Whenever you add a new security configuration, please start by writing a test that checks for this configuration. For example: If you want to set a new attribute in a configuration file, write a test that expects the value to be set first. Then implement your change.

You may add a new feature request by creating a test for whatever value you need.

All tests will be reviewed internally for their validity and overall project direction.


### Document your code

As code is more often read than written, please provide documentation in all projects. 

Adhere to the respective guidelines for documentation:

* Chef generally documents code based explicit readme files. For code documentation please use [yard-chef](https://github.com/rightscale/yard-chef)


### Follow coding styles

We generally include test for coding guidelines:

* Chef follows [Foodcritic](http://acrmp.github.io/foodcritic/)

Remember: Code is generally read much more often than written.


### Use Markdown

Wherever possible, please refrain from any other formats and stick to simple markdown.
