# Git Hooks

## Client side hooks

These hooks are run on a developer's workstation, mainly due to operation that involve new commit or modification of existing ones.

  * **pre-commit** is called before a commit occurs.
  * **prepare-commit-msg** lets you edit the default message before the editor is fired up; it's useful in automated commits to add some context.
  * **commit-msg** is the last step where you can interrupt a commit.
  * **post-commit** is executed after a commit is completed, for notification purposes.

Other client side hooks are not executed by the git commit command, and their names are self-explanatory:

  * **pre-rebase**
  * **post-checkout**
  * **post-merge**

Some special hooks need a description instead:

  * **post-rewrite** runs after some commits are amended or rebased.
  * **pre-auto-gc** runs before garbage collection takes place, and can interrupt it.

## Email workflow

`git am` uses these hooks (not a general case, but it's nice to know what they are). An email workflow means that patches are sent through alternative media (such as email attachments) instead of propagating commits via pushes and pulls. The hooks are:

  * **applypatch-msg**
  * **pre-applypatch**
  * **post-applypatch**

## Server side

These hooks are run on the receiving side of a push:

  * **pre-receive** can be used to check and interrupt the receival of the new commits, if it is the case.
  * **post-receive** notifies that commits have been published on this repository.
  * **update** is a version of pre-receive that is run once per each different branch.
  * **post-update** is a notification activated after all references have been updated; the default hook updates some metadata to let the repository be published via HTTP.


### References:

  * http://css.dzone.com/articles/all-git-hooks-you-need
