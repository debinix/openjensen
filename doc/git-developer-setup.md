## Git setup for new team developers in the OpenJensen project

This document describes what steps needs to be taken to be able to
collaborate with other team members in a potentially distributed way.

What this means is that every user in the project will have their own copy
of the repository, and importantly, *all these copies will have equal status*.
There are no master. Well conceptually at least, but we have decided a
that one repository (designated the **depot**) to be our central repository.

Every developer in the project push and pulls files to this private repository
which is located on the target host server. Once a software release is done
all files also pushed to the public GitHub repository with a version tag.


### Install git

Install git and gitk (revision tree visualizer):

    # aptitude install git
    # aptitude install gitk
    
Show current branch at your prompt (helpful) with this text in your ~/.bashrc:

    function parse_git_branch () {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    YELLOW="\[\033[0;33m\]"
    GREEN="\[\033[0;32m\]"
    NO_COLOUR="\[\033[0m\]"
    PS1="$YELLOW\u@\h$NO_COLOUR:\w$GREEN\$(parse_git_branch)$NO_COLOUR\$ "    
    

### Developer configurations    
    
Some information about yourself:

    $ git config --global user.name "YourName"
    $ git config --global user.email "your.name@example.com"

Continue and add some useful settings in the local ~/.gitconfig:

    $ nano ~/.gitconfig

Add these lines in the file:

    [user]
        name = YourName
        email = your.name@example.com
    [color]
        ui = auto
    [core]
        editor = /bin/nano
    [alias]
        com = commit
        sta = status
        sw2 = checkout
        nbr = checkout -b
        vhi =  **see below**
        vbr = branch -a
        vre = remote -v
        mer = merge --no-ff
        mef = merge --ff-only
        dif = diff --staged


### vhi alias

Show commit history with an alias in the ~/.gitconfig file:

    [alias]
    vhi = log --graph --pretty=format:'%Cred%h%Creset -%C(Yellow)%d%Creset%s%Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative


### Generate your developer SSH key

Unless you already have one password free ssh key, generate the key and accept
the defaults (give no password).

    $ ssh-keygen -b 4096 -C "your.name@example.com"
    
Find the new id_rsa.pub file in directory ~/.ssh.

Every new developer needs to send this generated ssh public key to the
Git administrator (i.e. debinix).


### Clone the remote repository

You are ready to work on the project, when the submitted public ssh key 
(~/id_rsa.pub) has been added to the git1 user on the depot server.

Create the local project directory:

    $ mkdir ~/projects
    $ cd ~/projects

Clone the project repository from the remote origin which were named *depot*
and the branch named depot/next:

    $ git clone -o depot -b next git1@217.70.39.231:/srv/git1/openjensen.git

Confirm that the repository was cloned:

    $ cd openjensen
    $ ls -l
    
    drwxr-xr-x 2 bekr bekr  4096 Feb  2 11:53 copy
    drwxr-xr-x 5 bekr bekr  4096 Feb  7 19:54 doc
    drwxr-xr-x 2 bekr bekr  4096 Jan 30 18:52 html
    drwxr-xr-x 2 bekr bekr  4096 Feb  7 14:02 lib
    -rw-r--r-- 1 bekr bekr 32472 Jan  1 22:04 LICENSE.txt
    -rw-r--r-- 1 bekr bekr  2308 Jan 30 18:51 makefile
    drwxr-xr-x 3 bekr bekr  4096 Jan 29 14:46 php
    drwxr-xr-x 2 bekr bekr  4096 Jan 31 11:40 postgresql
    -rw-r--r-- 1 bekr bekr  2177 Jan 16 13:00 README.komodo
    -rw-r--r-- 1 bekr bekr  2781 Feb  7 09:02 README.md
    drwxr-xr-x 2 bekr bekr  4096 Jan 29 14:24 src
    drwxr-xr-x 2 bekr bekr  4096 Feb  7 13:50 t
    -rw-r--r-- 1 bekr bekr   525 Jan 18 23:05 TODO.txt
    drwxr-xr-x 2 bekr bekr  4096 Feb  7 14:17 tools

Git push and pull configuration for his repository was automatically setup
by git since the project was cloned from the server.

View (v) the remote (re) configuration information:

    $ git vre
    
    depot	git1@217.70.39.231:/srv/git1/openjensen.git (fetch)
    depot	git1@217.70.39.231:/srv/git1/openjensen.git (push)

Now you are ready to work on the new project, but first learn how to work
with topic branches. But that's next part in this series.
