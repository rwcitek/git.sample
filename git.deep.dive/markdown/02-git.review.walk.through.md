# Walk through review basic usage

## Initialize and show current folder


```bash
cd ~/work
rm -rf example.repo.02
mkdir -p example.repo.02
tree example.repo.02
cd example.repo.02
```

<br />
<br />
<br />
<br />
<br />

## Initialize the folder to have it be tracked by git


```bash
git init
```


```bash
git config user.email "you@example.com"
git config user.name "Your Name"
```

<br />
<br />
<br />
<br />
<br />

## Verify that git has been initialized


```bash
git status
```


```bash
git config --list | grep ^user
```


```bash
ls -lA
```

<br />
<br />
<br />
<br />
<br />

## What is in the .git folder?

We'll find out in a little bit.

<br />
<br />
<br />
<br />
<br />

## Create a file


```bash
echo "Hello, world" > file.001
ls -lA
```


```bash
cat -n file.001
```

<br />
<br />
<br />
<br />
<br />

## Add file to the git repository (repo)


```bash
git add file.001
git status
```


```bash
git commit -m "file number one"
```


```bash
git status
```


```bash
git log
```

<br />
<br />
<br />
<br />
<br />

## What's that random stuff after the commit?
We'll find out in a little bit.

<br />
<br />
<br />
<br />
<br />

## Change contents of a tracked file


```bash
echo "Greetings, earthlings" > file.001
cat -n file.001
```


```bash
git status
```


```bash
git diff -- file.001
```

<br />
<br />
<br />
<br />
<br />

## Commit change to repository


```bash
git commit -am "changed salutation in file.001"
```


```bash
git status
```


```bash
git log
```

<br />
<br />
<br />
<br />
<br />

## Add another file


```bash
echo "Hello, world ... again" > file.002
ls -lA
```


```bash
cat -n file.002
```

<br />
<br />
<br />
<br />
<br />

## Commit new file to repository


```bash
git add file.002
git commit -m "new file file.002"
```


```bash
git log
```


```bash
git ls-files
```

<br />
<br />
<br />
<br />
<br />

## Summary of what happened
1. initialized and configured git repo
1. created a file
1. added and committed the file to the repo
1. changed the file
1. commited the changed file to the repo
1. created a new file
1. added and committed the new file to the repo

## Front-end vs Back-end
* front-end commands == "porcelain" commands
* back-end commands === "plumbing" commands <== magic

What we just did with the "procelain" commands, we are going to recreate using the "plumbing" commands
