## Git workflow

### Develop in topic branches

Create a new topic branch (here git-tutorial) from your local developer
integration branch and view status of what is tracked/changed:

    $ git nbr git-tutorial
    $ git sta
    # On branch git-tutorial
    nothing to commit (working directory clean)

Since nothing is changed or added, *git sta* shows that branch
*git-tutorial* is up to date (a.k.a. clean).

Change one file or add files (do that) and *git sta* again:

    $ git sta
    # On branch git-tutorial
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #	doc/git-workflow.md
    # nothing added to commit but untracked files present
    (use "git add" to track)

To add this new file to the stage use *git add* command:

    $ git add doc/git-workflow.md
    $ git sta
    # On branch git-tutorial
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	new file:   doc/git-workflow.md
    #

The new file is tracked (made aware of) by git. A lazy alternative to
git add <file> is *git add --all* or *git add .* but be prepared, you
may get more files staged than you first expect.

In that case, these can be un-staged with:

    $ git reset HEAD <file>
    
Finally commit the files to git *index* (the stage) with a comment:

    $ git commit -m 'Initial version'
    [git-tutorial ef6ede2] initial version of git workflow
    1 file changed, 17 insertions(+)
    create mode 100644 doc/git-workflow.md


### Integrate topic branch with local integration branch

If the branch is clean (check):

    $ git sta
    
    
Switch to the integration branch *next* with:

    $ git sw2
    
Merge in the changes in branch *git-tutorial* with:

    git mer git-tutorial
    
An editor will pop-up and ask for a merge comment.
Save and exit.


### Push local integration branch to remote integration branch

Update the remote depot/next with our updates with:

    git push
    
If push fails a local file needs to be edited. Git places markers
to guide you which text lines needs to changed.

    <<<<<<<<<<<<<< HEAD
    row 1 with text
    ==============
    row 1 with other text
    >>>>>>>>>>>>>

Decide which row should be kept and remove the other one.
Now remove the three marker rows (<<<<, ====, and >>>>).

Save the updated file. Prepare as usual:

    $ git add <file>
    $ git sta
    $ git com -m 'Fixed merge conflict'
    
    $ git push

This time, the *depot/next* push will be successful. Use gitk (graphic
commit history viewer) or *git vhi* to show full history:

    $ git vhi
    
or to limit to last 5 commits:

    $ git vhi -n5
    $ git vhi -n 5    

After the integration of the topic branch DO NOT switch back to the
old branch, dispose it an create a new branch off the current point
in the commit history to avoid a very confusing history.

Thus first dispose the old branch (now merged), and with the second
command create a new fresh start. This may also help not confuse some
graphical editor file caches.

    $ git branch -d git-tutorial
    $ git nbr git-tutorial-part-2

Happy coding.
    