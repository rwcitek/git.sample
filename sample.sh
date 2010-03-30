#!/bin/bash

set -x

###
# creates two sample data files for git to work with
###

# create a folder in which to work
[ -d sample ] && { echo "sample directory already exists" ; exit 1 ; }
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
git branch
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
git branch
git show-branch --all --more=100

# jump to exp branch
git checkout exp
git branch
git show-branch --all --more=100

# shrink exp branch back 6 snapshots
git reset --hard exp~6
git show-branch --all --more=100

