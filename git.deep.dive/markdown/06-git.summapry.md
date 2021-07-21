# Git Summary

## Simple in design
Uses existing tools on a standard Unix-like system
* the filesystem as a KV store
* sha-1 checksums
* zlib for compression/decompression

Uses simple abstractions
* key-value store
* hash functions
* graph

## Objects
* blobs
* trees
* commits
* references

# Next steps

## Middle sections of ProGit book
* branches and merges
* git server
* git services: GitHub, gitlab
* customizing: hooks, editor integration

## A local "remote" git repo


```bash
cd ~/work
rm -rf repo/ git.using.remote/
mkdir -p repo/ git.using.remote/
rsync -vaR example.repo.05/./.git/{HEAD,index,objects,refs} repo/
```


```bash
tree -a repo
```


```bash
# clone repo
cd git.using.remote
git clone ../repo/ .
```


```bash
# configure
git config user.email "you@example.com"
git config user.name "Your Name"
```


```bash
git status
```


```bash
git log
```


```bash
# Push to "remote" local repo
echo "hello again" > file.003
git add file.003
git commit -m "a third file"
git log
```


```bash
git push
```


```bash
# Display objects in "remote" local repo
cd ~/work/repo
tree .git/
```
