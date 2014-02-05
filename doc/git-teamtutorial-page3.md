### Public release on master

On branch next, update Changes file and any other files that contains a
reference to the version number.

If Alice does not intend to bring this particular change to a full release
she adds the change text, but leaves a template identifier like [% nextrev %]
or {{NEXT}} as a placeholder for the revisions number.

When she decides to release a new version, she first updates branch next with
the current authorized code from branch depot/next:

    $ git pull

Project files may also contain revision information. Edit these:

    < edit any project files that contains any revision number >

Finally, edit the file Changes and the template identifiers with the actual version information for this release:

    $ nano Changes
    < edit the Changes file with new version and save >

Run the unit test suit after any edits and then commit the code. These unit
tests are frequently run as a form of regression test in branch next.

    $ git add --all
    $ git sta
    $ git com -m 'version 0.0.2'

Before merging with master, tag it with the new version number:

    $ git tag -a v0.0.2 -m 'version 0.0.2'

View (v) the history (hi):

    $ git vhi
    
    * b437a9c - (HEAD, v0.0.2, next)version 0.0.2(52 seconds ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(25 minutes ago) <alice>
    |\
    | * 2eed2f7 - (milkshake)Added ice cream(49 minutes ago) <alice>
    | * 45cdbf2 -Added banana(52 minutes ago) <alice>
    | * d96a45c -Added milk(55 minutes ago) <alice>
    |/
    * 384b71b - (origin/master, depot/next, master)Initial commit(74 minutes ago) <alice>

Alice switch (sw) to (2) branch master for the public Github release:

    $ git sw2 master

View (v) the history (hi):

    $ git vhi
    
    * 384b71b - (HEAD, origin/master, depot/next, master)Initial commit(80 minutes ago) <alice>

Note that master branch only knows about the initial commit.

Merge branch next with a fast forward (always) into branch master.
The fast forward updates the branch pointer, without creating a merge commit:

    $ git mef next
    
    Updating 384b71b..b437a9c
    Fast-forward
    Changes | 5 ++++-
    README | 5 +++++
    2 files changed, 9 insertions(+), 1 deletion(-)

View (v) the history (hi):

    $ git vhi
    
    * b437a9c - (HEAD, v0.0.2, next, master)version 0.0.2(11 minutes ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(35 minutes ago) <alice>
    |\
    | * 2eed2f7 - (milkshake)Added ice cream(59 minutes ago) <alice>
    | * 45cdbf2 -Added banana(62 minutes ago) <alice>
    | * d96a45c -Added milk(65 minutes ago) <alice>
    |/
    * 384b71b - (origin/master, depot/next)Initial commit(84 minutes ago) <alice>

Now HEAD, next and master have been aligned with the git merge alias git mef.

Push the new version to the public repository origin/master at Github:

    $ git push
    
    Counting objects: 17, done.
    Compressing objects: 100% (14/14), done.
    Writing objects: 100% (14/14), 1.43 KiB, done.
    Total 14 (delta 8), reused 0 (delta 0)
    To https://github.com/alice/My-Module.git
    b2b4804..506483c master -> master

Note that that branch depot/next is not updated with these recent changes.

 
### Update branch depot/next and dispose the topic branch

Switch (sw) to (2) branch next again.

    $ git sw2 next
    
    Switched to branch 'next'
    Your branch is ahead of 'depot/next' by 5 commits.

Branch depot/next is still at the original commit as seen with:

    $ git vhi
    
    * b437a9c - (HEAD, v0.0.2, origin/master, next, master)version 0.0.2(16 minutes ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(41 minutes ago) <alice>
    |\
    | * 2eed2f7 - (milkshake)Added ice cream(65 minutes ago) <alice>
    | * 45cdbf2 -Added banana(68 minutes ago) <alice>
    | * d96a45c -Added milk(70 minutes ago) <alice>
    |/
    * 384b71b - (depot/next)Initial commit(2 hours ago) <alice>

Update branch depot/next with a push:

    $ git push

Any other team developer can now pull down recent updates from depot/next to
their local desktop before branching off in a new topic branch.

Dispose the milkshake branch with:

    $ git branch -d milkshake
    
    Deleted branch milkshake (was c9e0441).

 
### Add developer Bill to My-Module project.

Install git and gitk (revision tree visualizer) at Bills machine with:

    # aptitude install git
    # aptitude install gitk

Bill is ready to work on the project, when his public ssh key (~/id_rsa.pub)
has been added to the git1 user on the depot server (see first page).
Set up git user information:

    $ git config --global user.name "Bill"
    $ git config --global user.email "bill@example.com"

Add the git aliases (see first page) and set up the local project directory:

    $ mkdir ~/projects
    $ cd ~/projects

Clone the project repository from the remote origin which were named depot
and the branch named depot/next:

    $ git clone -o depot -b next git1@192.168.0.100:/srv/git1/My-Module.git

Confirm that the repository was cloned:

    $ cd My-Module
    $ ls -l
    
    -rw-r--r-- 1 bill bill 429 Dec 14 11:14 Build.PL
    -rw-r--r-- 1 bill bill 90 Dec 14 11:14 Changes
    drwxr-xr-x 3 bill bill 4096 Dec 14 11:14 lib
    -rw-r--r-- 1 bill bill 123 Dec 14 11:14 MANIFEST
    -rw-r--r-- 1 bill bill 979 Dec 14 11:14 README
    drwxr-xr-x 2 bill bill 4096 Dec 14 11:14 t

Now Bill is ready to work on the new project.

Git push and pull configuration for his repository was automatically setup
by git since the project was cloned from the server.

View (v) the remote (re) configuration information:

    $ git vre
    
    depot git1@192.168.0.100:/srv/git1/My-Module.git (fetch)
    depot git1@192.168.0.100:/srv/git1/My-Module.git (push)

 
### Bill commits new code.

Bill pulls down the latest code from branch depot/next before his topic branch
is created. Note that a pull is a fetch from depot/next followed by a merge in
Bills local next branch.

    $ git pull

He decides to modify the build file Build.PL. His plan is to replace the
artistic2 license with Perls. Create a topic branch for this:

    $ git nbr build-license

Open the file Build.PL with an editor:

    $ nano Build.PL
    < change the license from 'artistic2' to 'perl' and save file >

Add and commit changes:

    $ git add --all
    $ git sta
    $ git com -m 'use perl license'

Switch (sw) to (2) branch next and merge in his new code:

    $ git sw2 next
    $ git mer build-license

Update the Changes file but leave out the version number since this have to
wait for some future point in time when to release. Edit Changes file:

    $ nano Changes
    < edit the Changes file with new version text and save file >

Run the unit test suit again after all edits then commit the new code.

    $ git add --all
    $ git sta
    $ git com -m 'added license change'

Finally, update the remote branch depot/next:

    $ git push

After this Bill can continue to create new topic branches.

In the case depot/next development have progressed by other team members,
Bills push fails with:

    $ git push

    To git1@192.168.0.100:/srv/git1/My-Module.git
    ! [rejected] next -> next (non-fast-forward)
    error: failed to push some refs to 'git1@192.168.0.100:/srv/git1/My-Module.git'

This means that Bill must pull from branch depot/next and resolve any conflicts
by editing the file and committing again. After this he can push his changes:

    $ git pull
    < edit conflicting file and commit it again >
    $ git push
