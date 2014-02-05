## Git Lite Workflow configuration

### Workflow organization

Alice and Bill have agreed on an easy to use workflow model for
their project. Two long-lived branch exists and a number of
shorter-lived local topic branches.

Activities in branch master (i.e. for public released code).

    Never, ever, do any development here. This master is for stable releases.
    Release new code by merging with a fast-forward, from next.
    Push master branch to Github to release this new version.

The integration branch next.

    Branch next suppose to be stable most of the time.
    New code from topic branches are merged into next by each developer.
    A release is initiated in the Changes file and with a git version tag.
    Each developer updates this Changes file when topics have been merged in.

Local shorter-lived topic branches.

    Always code in topics branches (bug fixes, new features, documentation).
    Create new topic branches from the authorized branch depot/next.
    New code is merged into next after successful local unit testing.

Naturally, other workflow models exists but the point here is to practice,
and modify to find out what works best in your team. Simplicity is the focus
here. Depending on the language used for the project the file Changes may be
named differently but its role is similar.

 
### Public repository preparations

To follow this howto a Github hosted repository is required. In this example
its assumed that the public user is alice and at this point of the tutorial
the repository url is similar to:

    https://github.com/alice/My-Module.git

This howto push an existing repository to this Github repository. 
Alice creates project My-Module

Create the new project My-Module (without .git) with module-starter.

    $ mkdir ~/projects
    $ cd ~/projects
    $ module-starter --module=My::Module --dir=My-Module
                                    --builder=Module::Build --verbose

This created a start set of files for the project in My-Module directory:

    $ cd My-Module
    $ ls -l
    
    -rw-r--r-- 1 alice alice 429 Dec 14 11:14 Build.PL
    -rw-r--r-- 1 alice alice 90 Dec 14 11:14 Changes
    drwxr-xr-x 3 alice alice 4096 Dec 14 11:14 lib
    -rw-r--r-- 1 alice alice 123 Dec 14 11:14 MANIFEST
    -rw-r--r-- 1 alice alice 979 Dec 14 11:14 README
    drwxr-xr-x 2 alice alice 4096 Dec 14 11:14 t

Initialize the git repository:

    $ git init
    Initialized empty Git repository in /home/alice/projects/My-Module.git/

Add a shortcut url to upstream origin repository for branch master:

    $ git remote add origin https://github.com/alice/My-Module.git

View (v) the remote (re) repository shortcuts:

    $ git vre
    
    origin https://github.com/alice/My-Module.git (fetch)
    origin https://github.com/alice/My-Module.git (push)

Add all project files to master branch and commit:

    $ git add --all
    $ git sta
    $ git com -m 'Initial commit'

Push first commit to Github:

    $ git push -u origin master
    
    Counting objects: 14, done.
    Compressing objects: 100% (12/12), done.
    Writing objects: 100% (14/14), 4.33 KiB, done.
    Total 14 (delta 0), reused 0 (delta 0)
    To https://github.com/alice/My-Module.git
    * [new branch] master -> master
    Branch master set up to track remote branch master from origin.

You only need to add option -u (--set-upstream) the first time you push.
After this you can push to Github without any additional parameters in the
push command as long as your current branch is master.

 
### Configure the remote server depot/next

Alice names the project and adds a shortcut to the authorized depot to
be used for all team members in her project:

    $ git remote add depot git1@192.168.0.100:/srv/git1/My-Module.git

View (v) all remote (re) repository shortcuts:

    $ git vre
    
    depot git1@192.168.0.100:/srv/git1/My-Module.git (fetch)
    depot git1@192.168.0.100:/srv/git1/My-Module.git (push)
    origin https://github.com/alice/My-Module.git (fetch)
    origin https://github.com/alice/My-Module.git (push)

Note that a push or pull or fetch depends the current branch. See Note 1
on last page, howto change the prompt to show your current branch.

 
### Create and push the next branch to depot server

Following the concepts of Gite Lite Workflow create a new (n) local
integration branch (br) next:

    $ git nbr next
    
    $ git push -u depot next
    
    Counting objects: 14, done.
    Compressing objects: 100% (12/12), done.
    Writing objects: 100% (14/14), 4.33 KiB, done.
    Total 14 (delta 0), reused 0 (delta 0)
    To git1@192.168.0.100:/srv/git1/My-Module.git
    * [new branch] next -> next
    Branch next set up to track remote branch next from depot.

The last command pushed master branch content to depot/next and configured
depot/next as the upstream branch when current branch is next.

Create a new (n) milkshake topic branch (br) for initial project code:

    $ git nbr milkshake

View (v) all branches (br):

    $ git vbr
    
    master
    next
    * milkshake
    remotes/depot/next
    remotes/origin/master

When a new branch is created its made the current branch.

 
### Development work

Alice works on her milkshake topic branch and commit three times.

Open the README file in an editor:

    <edit README: add a new text line and the word "milk." >
    $ git add --all
    $ git sta
    $ git com -m 'Added milk'

Continue to change the file:

    <edit README: add a new text line and the word "banana.">
    $ git add --all
    $ git sta
    $ git com -m 'Added banana'

Finally the third time additions:

    <edit README: add a new text line and the word "ice cream.">
    $ git add --all
    $ git sta
    $ git com -m 'Added ice cream'

Note that using git dif where git sta is used above would have shown the
changes in the staged files compared to latest commit.

View (v) history (hi) of commits:

    $ git vhi
    
    * 2eed2f7 - (HEAD, milkshake)Added ice cream(8 minutes ago) <alice>
    * 45cdbf2 -Added banana(11 minutes ago) <alice>
    * d96a45c -Added milk(14 minutes ago) <alice>
    * 384b71b - (origin/master, depot/next, next, master)Initial commit(33 minutes ago) <alice>

See Note 2, last page, for the git vhi alias. Use gitk as an alternative command
to view commit history:

    $ gitk

When the milkshake code have passed the unit test suit it is merged into next branch.

Switch (sw) to (2) next and merge changes into next with option --no-ff:

    $ git sw2 next
    
    $ git mer milkshake
    
    Merge made by the 'recursive' strategy.
    README | 5 +++++
    1 file changed, 5 insertions(+)

The git mer alias takes care of the --no-ff option. View (v) commit history (hi)
after the last merge:

    $ git vhi
    
    * 5164966 - (HEAD, next)Merge branch 'milkshake' into next(79 seconds ago) <alice>
    |\
    | * 2eed2f7 - (milkshake)Added ice cream(25 minutes ago) <alice>
    | * 45cdbf2 -Added banana(28 minutes ago) <alice>
    | * d96a45c -Added milk(31 minutes ago) <alice>
    |/
    * 384b71b - (origin/master, depot/next, master)Initial commit(50 minutes ago) <alice>
