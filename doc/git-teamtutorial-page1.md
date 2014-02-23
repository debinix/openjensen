## Debian Wheezy Local Git Server With Git Lite Workflow

### Introduction

This howto describes a shared local git [1] server setup for a small team.
This is a repository layout that is familiar to anyone used to working with
a traditional version control system.

One of the tutorial objectives is to show detailed steps to prepare the server
(here called the depot because of its authoritative role) and publish the code
on a public service like Github, Gitorious [2,3] et. al.

A second objective is to introduce the Git Lite Workflow in team development.
This serves as an introduction to gits powerful branch and merge features.
Your personal favorite workflow may be different compared to this model.
For a feature rich workflow albeit more complex, see nvie [4].

To facilitate the description we have two team members. Alice, who code and is
responsible for all releases. A second team developer is Bill. Their shared git
server have the private IP address 192.168.0.100.

They both work for an open source friendly company EXAMPLE with domain
example.com. Alice have set up a project repository at Github with the
url https://github.com/alice/My-Module.git.

If you want to replay this howto, set up a free public Github repository.
Follow Githubs instructions but do not add README or .gitignore files.
This howto push an existing repository to this Github repository.

This tutorial has been tested on Debian Wheezy with following versions:

    $ uname -a ; lsb_release -d ; git --version ; ssh -V
    
    Linux debinix 3.2.0-4-686-pae #1 SMP Debian 3.2.32-1 i686 GNU/Linux
    Description: Debian GNU/Linux testing (wheezy)
    git version 1.7.10.4
    OpenSSH_6.0p1 Debian-3, OpenSSL 1.0.1c 10 May 2012

 
### Install git on the server

Install git and create a git1 user on the depot server to authorize git
push and pull access. As an extra precaution restrict this git1 user to
only doing git activities with a limited shell tool called git-shell.
This is included with git. With this as shell our git1 user can't have
normal shell access to the git server.

    # aptitude install git

Add a new password for this git1 user in the adduser script and use e.g.
Git Group 1 as Full Name.

    # adduser --shell /usr/bin/git-shell git1

If very fine-grained access control is required then look at the
gitolite project [5].

Confirm that git1 user shell is set to git-shell with:

    # cat /etc/passwd | grep git1

Git first time settings includes adding depot user information:

    # git config --system user.name "Git Depot"
    # git config --system user.email "root@example.com"

Server tasks can be performed remotely if secure shell is installed.
If not already installed, install it with:

    # aptitude install openssh-server

 
### Create the shared git project depot on the server

The root of the depot is e.g. created below /srv with:

    # mkdir /srv/git1
    # chown root:git1 /srv/git1
    # chmod 0750 /srv/git1

Create a project and name it e.g. My-Module.git:

    # mkdir /srv/git1/My-Module.git
    # chmod 0750 /srv/git1/My-Module.git

Initialize a bare git repository in the project directory:

    # cd /srv/git1/My-Module.git
    # git --bare init
    # chown -R git1:git1 /srv/git1/My-Module.git

Repeat these last five steps to setup a new project on the depot server.

 
### Project authentication for git users

Users authenticate with ssh keys. Alice and Bill does not need a password
for the key itself since git on the server use the git1 account password
for authorization. Note: There is no need to create a new ssh key if it
already exist. Use it also for the git server.

On Alice workstation, switch user to alice and accept the default ssh-keygen
options when creating her key:

    # su alice
    $ ssh-keygen

This created the id_rsa.pub file in directory ~/.ssh.

Copy her public key to the depot server (not the private key!).

    $ exit
    # scp /home/alice/.ssh/id_rsa.pub root@192.168.0.100:/tmp

Use ssh to access the depot sever at address 192.168.0.100:

    # ssh root@192.168.0.100
    root@192.168.0.100's password: *********

Once logged in at the server, append this key to git1 authorization_keys
file in /home/git1/.ssh. Adding new users can be done with a shell script:

    # cd /usr/local/bin
    # nano ssh.addkey

In this file add:

    #!/bin/sh
    test  !  -d  /home/$1/.ssh && mkdir  /home/$1/.ssh
    chmod  0700  /home/$1/.ssh
    cat  /tmp/id_rsa.pub  >>  /home/$1/.ssh/authorized_keys
    chmod  0600  /home/$1/.ssh/authorized_keys
    chown  -R  $1:$1  /home/$1/.ssh
    rm  /tmp/id_rsa.pub

Save it and make this script executable:

    # chmod 0700 ssh.addkey
    # exit

Add appropriate error checks to this script. Whenever a new user needs to
be added to group git1 on depot server invoke it like so:

    # ssh root@192.168.0.100 ssh.addkey git1

Don't forget to copy the ssh key to directory /tmp on the server first.

 
### Desktop (Alice) git preparations

Install git and gitk (revision tree visualizer) on alice machine:

    # aptitude install git
    # aptitude install gitk

Add some information about Alice:

    # su alice
    $ git config --global user.name "Alice"
    $ git config --global user.email "alice@example.com"

Continue and add some useful settings in ~/.gitconfig:

    $ nano ~/.gitconfig

Add these lines in the file:

    [user]
        name = Alice
        email = alice@example.com
    [color]
        ui = auto
    [core]
        editor = /bin/nano
    [alias]
        com = commit
        sta = status
        sw2 = checkout
        nbr = checkout -b
        vhi =  <see Note 2>
        vbr = branch -a
        vre = remote -v
        mer = merge --no-ff
        mef = merge --ff-only
        dif = diff --staged

The merge option, --no-ff, helps maintaining the history, for which commits
implemented a specific feature, after it have been merged into another branch.

Naturally you can put any development files you like in the project directory
but for the purpose of this howto Alice plans a new Perl module. Alice
initiate the new Perl project wisely and install one Comprehensive Perl
Archive Network (CPAN [6]) distribution that helps create a good start set
of files called Module::Starter::PBP.

    # aptitude install libmodule-starter-pbp-perl

To set up module-starter (i.e. setup its configuration and templates), run as user alice:

    $ perl -MModule::Starter::PBP=setup
    
    Creating /home/alice/.module-starter/PBP...done.
    Creating /home/alice/.module-starter/PBP/t...done.
    Creating /home/alice/.module-starter/config...
    Please enter your full name: Alice Wonderland
    Please enter an email address: alice@example.com
    Writing /home/alice/.module-starter/config...
    done.
    Installing templates...
    /home/alice/.module-starter/PBP/Build.PL...done
    /home/alice/.module-starter/PBP/Makefile.PL...done
    /home/alice/.module-starter/PBP/README...done
    /home/alice/.module-starter/PBP/Changes...done
    /home/alice/.module-starter/PBP/Module.pm...done
    /home/alice/.module-starter/PBP/t/pod-coverage.t...done
    /home/alice/.module-starter/PBP/t/pod.t...done
    /home/alice/.module-starter/PBP/t/perlcritic.t...done
    Installation complete.

The configuration file is in ~/.module-starter.

Option: To install the latest Module::Starter::PBP module direct from CPAN use
the Perl installer tool cpanminus. As root install cpanminus:

    # aptitude install cpanminus
    # cpanm Module::Starter::PBP

