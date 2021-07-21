# The .git folder

What's in it?
Let's do the walk through again and explore.

## Initialize and show current folder


```bash
cd ~/work
rm -rf example.repo.03
mkdir -p example.repo.03
tree example.repo.03
cd example.repo.03
```

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

# The repository
The "repo" consists of four items in the .git folder: two folders and two files.
* Folders:
    * objects
    * refs
* Files:
    * HEAD
    * index




```bash
ls -lF .git/{HEAD,index}
tree .git/{objects,refs}
```


```bash
cat .git/HEAD
```

<br />
<br />
<br />
<br />
<br />

# Creating a file and adding and commiting to the repo


```bash
echo "Hello, world" > file.001
git add file.001
git commit -m "file number one"
```


```bash
git log
```

## Look at .git folder and how it has changed


```bash
ls -lF .git/{HEAD,index}
tree .git/{objects,refs}
```

Of note ...
* we now have three files in the object folder hierarchy
* the random characters after the commit matches one of the items in the objects hierarchy
* a file named master in the references/head folder
* an index file

These are all the componenets of a git repository.

<br />
<br />
<br />
<br />
<br />

## Summary of observations
* initialization creates a .git folder
* in that folder are more files and folders
* a repository is only four of those folders/files: objects, refs, HEAD, index
* the random characters in the commit log match those in the objects folder ... mostly

