---
layout: post
title: Revert all your commits in a git repository
type: post
excerpt: git rev-list can handle quite a bit of magic. And some pepper, too.

---

Recently I had to deal with the following task: we had to revert a set of commits in a git repository and
do it with as little pain as possible. All of those commits were mine, and I used several emails along the way.

First, I looked into the project's Github page and found the total number of commits I did in the *Graphs/Contributors*. Github told me I had 55 commits in the repo.

Then I had to compare the number with the number of my own commits in the code I have, to make sure that everything is fine and I won't be deleting any other commits.

This was done using the following command:

    git rev-list --all --author='Ivan Zarea' --format=oneline

I added the `oneline` format so that I could see the commit messages and be sure that there's no other commits in the output.
The command gave me 55 commits - the same as Github. We can begin.

Now all we have to do is pass each of the revs to the `git revert`:

    git rev-list --all --author='Ivan Zarea' | xargs git revert -n

Note the `-n` option (equivalent to `--no-commit`). With `git revert` it doesn't create a commit which, in our case, allows us to create one huge commit with all the changes.

Commit, Push and that's it!












