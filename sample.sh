#!/bin/bash

###
# creates two sample data files for git to work with
###

# create a folder in which to work
[ -d sample ] && { echo "sample directory already exists" ; exit 1 ; }
mkdir sample
cd sample

# initialize repository
git init
touch data1.txt data2.txt
git add data1.txt data2.txt
git commit -a -m "initial commit"
echo "the log after one addition ..."
git log --pretty=oneline

# edit, commit cycle
for i in {1..4} ; do
  echo "item $i" >> data1.txt
  git commit -a -m "add item $i to data1.txt"
  echo "copy item $i" >> data2.txt
  git commit -a -m "add item $i to data2.txt"
done > /dev/null
echo "the log after several addition ..."
git log --pretty=oneline
