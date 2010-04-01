#!/bin/bash

set -x

###
# creates two sample data files for git to work with
###

# create a folder in which to work
[ -d myProj ] && { echo "myProj directory already exists" ; exit 1 ; }
mkdir myProj
cd myProj

# initialize repository
git init
touch data1.txt data2.txt
git add data1.txt data2.txt
git commit -a -m "initial commit"

# edit, commit cycle
for i in {1..7} ; do
  echo "item $i" >> data1.txt
  git commit -a -m "add item $i to data1.txt"
  echo "copy item $i" >> data2.txt
  git commit -a -m "add item $i to data2.txt"
done > /dev/null

# examine repository
git log --pretty=oneline
git branch -a
git show-branch --all --more=100 --sha1-name
git show-branch --all --more=100

# revert an edit
head -v data1.txt
echo "bad data" >> data1.txt
head -v data1.txt
git reset --hard master
head -v data1.txt

# revert a commit
git log --pretty=oneline
head -v data1.txt
echo "bad data" >> data1.txt
git commit -a -m "add bad data to data1.txt"
git log --pretty=oneline
head -v data1.txt
git reset --hard master~1
head -v data1.txt
git log --pretty=oneline

# name a snapshot
git tag -m "Version 1" v01 master~5
git tag -n1
git log --pretty=oneline v01 -1

# create a branch
git branch exp v01
git branch -a
git show-branch --all --more=100

# jump to exp branch
git checkout exp
git branch -a
git show-branch --all --more=100

# shrink exp branch back 6 snapshots
git reset --hard exp~6
git show-branch --all --more=100

# grow exp branch to be same as master
git merge master
git show-branch --all --more=100

# look at tagged snapshot and create pseudo-branch.
# you can jump to snapshots just like branches,
# except they are like Teflon: you can take snapshots,
# but they don't stick.  When you jump again, they're gone.
# valid snapshot names include sha1, nicknames, tags, relative branch names
git checkout v01
git branch -a
git show-branch --all --more=100
git log --pretty=oneline 
echo "bad data" >> data1.txt
git commit -a -m "add bad data to data1.txt"
git log --pretty=oneline 
git show-branch --all --more=100
git checkout v01
head -v data1.txt
git log --pretty=oneline 

# clone a remote repository
# note that local copy of remote branch is called origin/
git clone http://github.com/rwcitek/git.sample.git
cd git.sample/
git show-branch --all --more=100
git branch -a

# shrink master branch
git reset --hard 15bb7c9
git show-branch --all --more=100

# grow master branch using merge with origin/
git merge origin/master~5
git show-branch --all --more=100

# update origin/ with remote repository
git fetch
git show-branch --all --more=100

# update origin/master from remote repository and merge in one step
git pull http://github.com/rwcitek/git.sample.git master
git show-branch --all --more=100

# update origin/ from current branch and update remote repository from origin/
# need to provide git or ssh url, http is read-only
git push git@github.com:rwcitek/git.sample.git
git show-branch --all --more=100

