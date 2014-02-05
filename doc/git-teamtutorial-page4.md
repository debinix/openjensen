### Hot bug fix in released code.

Alice noticed that the README file for public version 0.0.2 release still
refers to version 0.0.1. She decides to create a hot bug fix for this.

Note that the stability in branch next may not be such that it can be merged
into master to correct the bug in the already released code.

Alice updates branch next before she creates a new hot bug fix topic branch
from a suitable point in the commit history.

Switch (sw) to (2) branch next:

    $ git sw2 next
    $ git pull

After the pull, history looks like:

    $ git vhi
    
    * a57f287 - (HEAD, depot/next, next)added perl license(26 minutes ago) <bill>
    * 8d51eac -Merge branch 'build-license' into next(56 minutes ago) <bill>
    |\
    | * 40f6a65 -use perl license(67 minutes ago) <bill>
    |/
    * b437a9c - (v0.0.2, origin/master, master)version 0.0.2(2 hours ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(2 hours ago) <alice>
    |\
    | * 2eed2f7 -Added ice cream(3 hours ago) <alice>
    | * 45cdbf2 -Added banana(3 hours ago) <alice>
    | * d96a45c -Added milk(3 hours ago) <alice>
    |/
    * 384b71b -Initial commit(3 hours ago) <alice>

Create a new (n) branch (br) named bugfix1. Branch from commit b437a9c or use
git tag v0.0.2 for this new branch:

    $ git nbr bugfix1 v0.0.2

This branch bugfix1 points at the last public release:

    $ git vhi
    
    * b437a9c - (HEAD, v0.0.2, origin/master, master, bugfix1)version 0.0.2(2 hours ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(3 hours ago) <alice>
    |\
    | * 2eed2f7 -Added ice cream(3 hours ago) <alice>
    | * 45cdbf2 -Added banana(3 hours ago) <alice>
    | * d96a45c -Added milk(3 hours ago) <alice>
    |/
    * 384b71b -Initial commit(3 hours ago) <alice>

Fix the bug in the README file:

    $ nano README
    < change version to '0.0.3' and save file >

Update the Changes file:

    $ nano Changes
    < add change text describing version 0.0.3 and save file >

Finally add and commit:

    $ git add --all
    $ git sta
    $ git com -m 'Bug#1: wrong version in README'

While working in branch next, tag the new public release before merging
with branch master:

    $ git tag -a v0.0.3 -m 'version 0.0.3'

Switch (sw) to (2) branch master :

    $ git sw2 master

View (v) all branches (br):

    $ git vbr
    
    bugfix1
    * master
    next
    remotes/depot/next
    remotes/origin/master

Merge changes into master with option fast-forward (always):

    $ git mef bugfix1
    
    Updating b437a9c..a407b79
    Fast-forward
    Changes | 3 +++
    README | 2 +-
    2 files changed, 4 insertions(+), 1 deletion(-)

Finally, push this bug fix to the public Github repository:

    $ git push

 
### Merge back the bug fix into the integration branch.

Switch branch to next:

    $ git sw2 next

View (v) all branches (br):

    $ git vbr
    
    bugfix1
    master
    * next
    remotes/depot/next
    remotes/origin/master

Merge the bug fix into next (always recursive, when not in master):

    $ git mer bugfix1
    
    Auto-merging Changes
    CONFLICT (content): Merge conflict in Changes
    Automatic merge failed; fix conflicts and then commit the result.

Git puts help marks in the Changes file to show conflicting text lines.
Edit the file with:

$ nano Changes

Original file:

    Revision history for My-Module
    <<<<<<< HEAD
    [% nextrev %]
           Use perl license.
    =======
    0.0.3  Tue Dec 25 16:30 2012
           Bugfix: Wrong version in README.
    >>>>>>> bugfix1
    0.0.2  Tue Dec 25 13:51 2012
           Added milkshake.
    0.0.1  Tue Dec 25 12:40 2012
           Initial release.

Correct Changes as below and save file:

    Revision history for My-Module
    [% nextrev %]
           Use perl license.
    0.0.3  Tue Dec 25 16:30 2012
           Bugfix: Wrong version in README.
    0.0.2  Tue Dec 25 13:51 2012
           Added milkshake.
    0.0.1  Tue Dec 25 12:40 2012
           Initial release.

Add and commit:

    $ git add --all
    $ git sta
    $ git com -m 'Corrected Changes file'

View (v) current history (hi):

    $ git vhi
    
    * d722edf - (HEAD, next)Corrected Changes file(2 minutes ago) <alice>
    |\
    | * a407b79 - (v0.0.3, origin/master, master, bugfix1)Bugfix#1: wrong version in README(79 minutes ago) <alice>
    * | a57f287 - (depot/next)added perl license(2 hours ago) <bill>
    * | 8d51eac -Merge branch 'build-license' into next(3 hours ago) <bill>
    |\ \
    | |/
    |/|
    | * 40f6a65 -use perl license(3 hours ago) <bill>
    |/
    * b437a9c - (v0.0.2)version 0.0.2(4 hours ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(4 hours ago) <alice>
    |\
    | * 2eed2f7 -Added ice cream(5 hours ago) <alice>
    | * 45cdbf2 -Added banana(5 hours ago) <alice>
    | * d96a45c -Added milk(5 hours ago) <alice>
    |/
    * 384b71b -Initial commit(5 hours ago) <alice>

Push next to update depot/next:

    $ git push
    
    Counting objects: 12, done.
    Compressing objects: 100% (7/7), done.
    Writing objects: 100% (7/7), 716 bytes, done.
    Total 7 (delta 5), reused 0 (delta 0)
    To git1@192.168.0.100:/srv/git1/My-Module.git
    a57f287..d722edf next -> next

View (v) the updated history (hi):

    $ git vhi
    
    * d722edf - (HEAD, depot/next, next)Corrected Changes file(55 minutes ago) <alice>
    |\
    | * a407b79 - (v0.0.3, origin/master, master, bugfix1)Bugfix#1: wrong version in README(2 hours ago)
    * | a57f287 -added perl license(3 hours ago) <bill>
    * | 8d51eac -Merge branch 'build-license' into next(4 hours ago) <bill>
    |\ \
    | |/
    |/|
    | * 40f6a65 -use perl license(4 hours ago) <bill>
    |/
    * b437a9c - (v0.0.2)version 0.0.2(5 hours ago) <alice>
    * 5164966 -Merge branch 'milkshake' into next(5 hours ago) <alice>
    |\
    | * 2eed2f7 -Added ice cream(6 hours ago) <alice>
    | * 45cdbf2 -Added banana(6 hours ago) <alice>
    | * d96a45c -Added milk(6 hours ago) <alice>
    |/
    * 384b71b -Initial commit(6 hours ago) <alice>

This completes the bug fix. Dispose the bugfix1 branch:

    $ git branch -d bugfix1
    
    Deleted branch bugfix1 (was a407b79).

 
### Troubleshooting

Error message when Github repository have not yet been created:

    $ git remote add origin https://github.com/alice/My-Module.git
    $ git push -u origin master
    
    Username for 'https://github.com': alice
    Password for 'https://alice@github.com': ********
    fatal: https://github.com/alice/My-Module.git/info/refs not found:
    did you run git update-server-info on the server?

Error message when pushing to local git depot server with wrong url:

    $ git remote add depot git1@192.168.0.100:/srv/git1/My-Modules.git
    $ git nbr next
    $ git push -u depot next
    
    git1@192.168.0.100's password: *******
    fatal: '/srv/git1/My-Modules.git' does not appear to be a git repository
    fatal: The remote end hung up unexpectedly

What is the url error in this case?

Error message if permissions is not correct for the depot directories:

    $ git remote add depot git1@192.168.0.100:/srv/git1/My-Module.git
    $ git nbr next
    $ git push -u depot next
    
    git1@192.168.0.100's password: *******
    fatal: '/srv/git1/My-Module.git' does not appear to be a git repository
    fatal: The remote end hung up unexpectedly

Ensure that git1 user ownerships are correct on the server:

    # chown root:git1 /srv/git1
    # chown -R git1:git1 /srv/git1/My-Module.git

 
### References

[1] [Git: http://git-scm.com](http://git-scm.com)

[2] [Github: https://github.com](https://github.com)

[3] [Gitorius: https://gitorious.org](https://gitorious.org)

[4] [nvie](http://nvie.com/posts/a-successful-git-branching-model)

[5] [Fine-grained access control](https://github.com/sitaramc/gitolite.git)

[6] [CPAN: http://www.cpan.org](http://www.cpan.org)

 
### Notes

Note1) Include current branch at your prompt with this text in your ~/.bashrc:

    function parse_git_branch () {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    YELLOW="\[\033[0;33m\]"
    GREEN="\[\033[0;32m\]"
    NO_COLOUR="\[\033[0m\]"
    PS1="$YELLOW\u@\h$NO_COLOUR:\w$GREEN\$(parse_git_branch)$NO_COLOUR\$ "

Source: Github Gist Code snippets

Note2) Show commit history as in this howto with an alias in the ~/.gitconfig file:

    [alias]
    vhi = log --graph --pretty=format:'%Cred%h%Creset -%C(Yellow)%d%Creset%s%Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative

For information about this git command see man git-log.
