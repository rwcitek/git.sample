# The plumbing: a walk through

## Initialize and show current folder


```bash
cd ~/work
rm -rf example.repo.05
mkdir -p example.repo.05
cd example.repo.05
git init
git config user.email "you@example.com"
git config user.name "Your Name"
```

## Verify that git has been initialized


```bash
git status
```


```bash
git config --list | grep ^user
```


```bash
tree .git/objects
```

<br />
<br />
<br />
<br />
<br />

## Create a file in the current working directory and add to KV store


```bash
echo "Hello, world" > file.001
ls -lA
```


```bash
cat -n file.001
```


```bash
# save the file and return the hash
git hash-object -w file.001
```

Notice that when we add a file to the KV store, we get back a key, which is the sha1 of the contents of the file ( almost. )


```bash
tree .git/objects
```

Notice that the sha we got back matches what is in the objects hierarchy.  In other words, the .git/objects hierarchy is the key-value store.

<br />
<br />
<br />
<br />
<br />

## Change the file and add it to the KV store


```bash
echo "Greetings, earthlings" > file.001
cat -n file.001
```


```bash
# save the file and return the hash
git hash-object -w file.001
```


```bash
tree .git/objects
```

We now have two objects: both from "file.001"

<br />
<br />
<br />
<br />
<br />

## Restore previous version of file.001


```bash
# View the current contents
ls -lA
cat file.001
```


```bash
# If we remember the key and the file name, we can restore the contents
git cat-file -p a5c19667710254f835085b99726e523457150e03 > file.001
cat file.001
```

<br />
<br />
<br />
<br />
<br />

## Git objects
Notice that we didn't store the name of the file or any other metadata ( e.g. permissions ), just the contents.  A file with only content is called a **blob**.  To store metadata, we need a new kind of git object.  In git there are four types of objects:
* blob
* tree
* commit
* reference ( tag )

You can query what type of object a file is by using the "-t" option to "git cat-file"


```bash
git cat-file -t a5c19667710254f835085b99726e523457150e03
```

Or the same for all objects in the .git/objects hierarchy


```bash
# Show the type of all objects
find .git/objects -type f |
cut -d/ -f3- |
tr -d '/' |
xargs -n1 -t git cat-file -t
```

To see the contents of all objects, use the "-p" option


```bash
# Show the contents of all objects
find .git/objects -type f |
cut -d/ -f3- |
tr -d '/' |
xargs -n1 -t git cat-file -p
```

<br />
<br />
<br />
<br />
<br />

## Create a tree
A tree is a collection of metadata and pointers to blobs or other trees.  The closest analogy would be a filesystem folder.


```bash
git update-index --add --cacheinfo 100644 a5c19667710254f835085b99726e523457150e03 file.001
git write-tree
```


```bash
# Show the type of all objects
find .git/objects -type f |
cut -d/ -f3- |
tr -d '/' |
xargs -n1 -t git cat-file -t |
cat -n
```


```bash
# Show the contents of all objects
find .git/objects -type f |
cut -d/ -f3- |
tr -d '/' |
xargs -n1 -t git cat-file -p |
cat -n 
```

<br />
<br />
<br />
<br />
<br />

## Stage the changed version of the first file


```bash
git update-index --add --cacheinfo 100644 34a27f74d7d73cd456ce426bfa20bffcfb8fd11c file.001

# write the tree
git write-tree
```


```bash
# Show the hash, type, and contents of objects
find .git/objects -type f | cut -d/ -f3- | tr -d '/' |
while read object ; do
  echo == ${object} $( git cat-file -t ${object} )
  git cat-file -p ${object}
  echo
done
```

<br />
<br />
<br />
<br />
<br />

<br />
<br />
<br />
<br />
<br />

## Create a new file and create a tree for it


```bash
echo "Hello, world ... again" > file.002
ls -lA
```


```bash
cat -n file.002
```


```bash
# for a file NOT in the KV store
git update-index --add file.002

# write the tree
git write-tree
```


```bash
# Show the hash, type, and contents of objects
find .git/objects -type f | cut -d/ -f3- | tr -d '/' |
while read object ; do
  echo == ${object} $( git cat-file -t ${object} )
  git cat-file -p ${object}
  echo
done
```

These trees represent the "snapshots" of the objects in your working directory.  Tree a13eb has the original file.001, tree 7f1b has the changed file.001, and tree e1df3 has both files file.001 and file.002.  Think of these trees as sub-graphs.  Blobs are end nodes.  Trees point to one or more blobs ( or other trees ).

What we have is similar to this:
![]( https://git-scm.com/book/en/v2/images/data-model-2.png )


Time to stitch the trees together with commits.

<br />
<br />
<br />
<br />
<br />

## Create a commit


```bash
commit_1=$( echo 'file number one' | git commit-tree a13eb9d02b9ee2c2f0d073bbc65d91a18c7e7316 )
echo ${commit_1}
```


```bash
git cat-file -p ${commit_1}
```


```bash
find .git/objects -type f | cut -d/ -f3- | tr -d '/' | sort |
while read object ; do
  echo == ${object} $( git cat-file -t ${object} )
  git cat-file -p ${object}
  echo
done
```

<br />
<br />
<br />
<br />
<br />

## Add the second commit


```bash
commit_2=$( echo 'changed salutation in file.001' | git commit-tree 7f1ba -p ${commit_1} )
echo ${commit_2}
```


```bash
find .git/objects -type f | cut -d/ -f3- | tr -d '/' | sort |
while read object ; do
  echo == ${object} $( git cat-file -t ${object} )
  git cat-file -p ${object}
  echo
done
```

<br />
<br />
<br />
<br />
<br />

## Add the third commit


```bash
commit_3=$( echo 'new file file.002' | git commit-tree e1df3 -p ${commit_2} )
echo ${commit_3}
```


```bash
find .git/objects -type f | cut -d/ -f3- | tr -d '/' | sort |
while read object ; do
  echo == ${object} $( git cat-file -t ${object} )
  git cat-file -p ${object}
  echo
done
```

## View the git log


```bash
git log --stat ${commit_3}
```

<br />
<br />
<br />
<br />
<br />

## Object storage
A bit of a rewind: I said that the object being stored is **mostly** the contents of the file.  Git actually prepends some metadata to the beginning of the file.


### Creating a git blob
Git prepends the type of object, the length of the object, and a null before the contents.


```bash
# Using git
text='test content'

echo -e "${text}" | git hash-object --stdin
```


```bash
# Manually
text='test content'
len=$( echo -e ${text} | wc -c | tr -d ' ' )

echo -e "blob ${len}\0${text}" | shasum -a 1 | tr -d '\n -'

```

### Reading the contents of a blob object


```bash
# Find a blob
blob_file=$(
    find .git/objects -type f |
    sort |
    while read file ; do
      <<< ${file} cut -d/ -f3- |
      tr -d '/' |
      xargs -n1 git cat-file -t |
      fgrep -q blob && echo ${file} && break
    done
)
echo ${blob_file}
```


```bash
# We can trick gzip to decompress zlib files by prepending some hex code
printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |
cat - ${blob_file} |
gzip -dc 2> /dev/null |
cat -vet
```


```bash
# Verify the hash
echo ${blob_file}
printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |
cat - ${blob_file} |
gzip -dc 2> /dev/null |
shasum
```


```bash
# Display the original contents
printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" |
cat - ${blob_file} |
gzip -dc 2> /dev/null |
sed -z '1d'
```

<br />
<br />
<br />
<br />
<br />

## One last item: references
There are four git objects.  We've covered three of them: blobs, trees, commits.  The last one is references.


```bash
tree .git/refs
```


```bash
# create a "master" branch
echo ${commit_3} > .git/refs/heads/master

git log --pretty=oneline master
```

**Don't do this** <br />
Use the plumbing commands.  Or better, the porcelain commands.



```bash
git update-ref refs/heads/master ${commit_3}
git log --pretty=oneline master
```

<br />
<br />
<br />
<br />
<br />

## Creating a branch
A branch is just a reference to a commit object.


```bash
git update-ref refs/heads/test ${commit_2}
git log --pretty=oneline test
```


```bash
git branch -a
```

Now we have something like this.
![]( https://git-scm.com/book/en/v2/images/data-model-4.png )

### The HEAD


```bash
cat .git/HEAD
```


```bash
git checkout test
```


```bash
cat .git/HEAD
```


```bash
git symbolic-ref HEAD
```


```bash
git branch -a
```


```bash
# manually setting the HEAD
git symbolic-ref HEAD refs/heads/master
cat .git/HEAD
```


```bash
git branch -a
```

## The Tag
There are two types of tags:
* lightweight
* annotated

#### Lightweight tag


```bash
# List tags hierarchy
tree .git/refs/tags
```


```bash
# Create a lightweight tag
git update-ref refs/tags/v1.0 ${commit_1}
```


```bash
# List tags
git tag
```


```bash
# List tags hierarchy
tree .git/refs/tags
```


```bash
# Show contents of tag
cat .git/refs/tags/v1.0
```

Notice that the tag is just a reference to an object.


```bash
# Display the type of the object that the tag references
cat .git/refs/tags/v1.0 |
xargs -t git cat-file -t |
cat -n
```


```bash
# Display the contents of the object that the tag references
cat .git/refs/tags/v1.0 |
xargs -t git cat-file -p |
cat -n
```

<br />

#### Annotated tag


```bash
# Create an annotated tag
git tag -a v1.1 ${commit_2} -m "Test tag"
```


```bash
git tag
```


```bash
# list tags hierarchy
tree .git/refs/tags/
```


```bash
# Display tag contents
cat .git/refs/tags/v1.1
```


```bash
# Display the type of the object that the tag references
cat .git/refs/tags/v1.1 |
xargs -t git cat-file -t |
cat -n
```


```bash
# Display the contents of the object that the tag references
cat .git/refs/tags/v1.1 |
xargs -t git cat-file -p |
cat -n
```
