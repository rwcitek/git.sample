#!/bin/bash

# creates a sample data file for git to work with

mkdir sample
cd sample
git init
touch data1.txt data2.txt
git add data1.txt data2.txt
git commit -a -m "initial commit"
echo "the log after one addition ..."
git log --pretty=oneline
for i in {1..10} ; do
  echo "item $i" >> data1.txt
  git commit -a -m "add item $i to data1.txt"
  echo "copy item $i" >> data2.txt
  git commit -a -m "add item $i to data2.txt"
done > /dev/null
echo "the log after several addition ..."
git log --pretty=oneline
