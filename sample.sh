#!/bin/bash

# creates a sample data file for git to work with

git init
touch data.txt
git add data.txt
git commit -a -m "initial commit"
echo "the log after one addition ..."
git log --pretty=oneline
for i in {1..10} ; do
  echo "item $i" >> data.txt
  git commit -a -m "add item $i"
done > /dev/null
echo "the log after several addition ..."
git log --pretty=oneline
