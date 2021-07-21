# Abstraction and technologies

Git uses a number of abstractions, technologies, and tools behind the scenes, organized in the .git folder hierarchy.

* filesystem
* hash function, CHF SHA-1
* compression
* key-value store
* graphs: trees, acyclic directed graphs ( DAGs )


<br />
<br />
<br />
<br />
<br />

## Initialize and show current folder


```bash
cd ~/work
rm -rf example.repo.04
mkdir -p example.repo.04
cd example.repo.04
git init
git config user.email "you@example.com"
git config user.name "Your Name"
```

## Filesystem


```bash
tree .git
```

A key feature of the file system is that no two files can have the same path/filename.  Those must be unique.


```bash
find ~/work/confusion
```


```bash
find ~/work/confusion | sort | cat -vet
```

<br />
<br />
<br />
<br />
<br />

## Hash functions
* Cryptographic hash functions ( CHF )
* SHA-1

### Properties, features
- fast to compute: O(n)
- uniform size: maps data of arbitrary size to a fixed size ( SHA-1: 40 hex digits )
- hex characters
- one-way: given a hash output, infeasible to generate input; irreversible
- deterministic: same input, same output
    - if two hashes differ, their inputs differ
- unique: infeasible that different inputs generate same output; collision
- sensitive to change: small input change, large output change; avalanche effect



```bash
# input size
<<< "hello world" wc -c
```


```bash
# same size, hex characters, and deterministic: calculate hash twice
<<< "hello world" shasum -a 1
<<< "hello world" shasum -a 1
```


```bash
# output size
<<< "hello world" shasum -a 1 | tr -d '\n -' | wc -c
```


```bash
# similar, but different input results in different output
<<< "hello world, hello world, hello world, hello world" shasum
```


```bash
# deterministic: repeat
<<< "hello world, hello world, hello world, hello world" shasum
```


```bash
# repeat ... almost: avalanche effect
<<< "hello world, hello world, hello wor1d, hello world" shasum
```

Reference: [Wikipedia on CHF]( https://en.wikipedia.org/wiki/Cryptographic_hash_function )


<br />
<br />
<br />
<br />
<br />

## Compression ( lossless )
- given input data, generate smaller output data ( usually )
- reversible: given output data, regenerate input data, exactly
- zip, gzip
- git uses zlib



```bash
# compress, notice reduced size
echo "hello world, hello world, hello world, hello world" > /tmp/example
< /tmp/example gzip > /tmp/example.compressed
ls -la /tmp/example*
```


```bash
# decompress
< /tmp/example.compressed gzip -dc
```


```bash
# virify hash
< /tmp/example shasum
< /tmp/example.compressed gzip -dc | shasum
```

Reference: [Wikipedia Compression]( https://en.wikipedia.org/wiki/Data_compression )

<br />
<br />
<br />
<br />
<br />

## Key-value store
- given a key, some value is returned
- DB: CRUD - create, remove, update, delete
- associative array ( awk ), hash ( perl, ruby ), dictionary (Python)
- implementations: Berkeley DB, redis, Dynamo, S3
- filesystem: no two files can have the same name

### Stiching the pieces together
- git uses sha-1 to generate a key, compresses the data, and then stores it on the filesystem
- result: 1-to-1 map of key to value

** This is NOT what git does, but it's a step in that direction **

#### Write to and read from the K-V store


```bash
# Save some data
echo "hello world, hello world, hello world, hello world" > /tmp/example
```


```bash
# Generate a key
key=$( < /tmp/example shasum | tr -d '\n -')
```


```bash
# Save the data using the key as filename
cat /tmp/example > /tmp/${key}
```


```bash
# Verify, i.e. files exist and are same size
ls -lAF /tmp/example /tmp/"${key}"
```


```bash
# Retrieve from the K-V store, given some key
cat /tmp/"${key}"
```


```bash
# Verify contents are the same
cat /tmp/example | shasum
cat /tmp/"${key}" | shasum
```

<br />

#### Repeat the same but with compression


```bash
# Save some data
echo "hello world, hello world, hello world, hello world" > /tmp/example
```


```bash
# Generate a key
key=$( < /tmp/example shasum | tr -d '\n -')
```


```bash
# Compress and save the data using the key as filename
< /tmp/example gzip -c > /tmp/${key}
```


```bash
# Verify, i.e. files exist and not compressed file is smaller than original
ls -lAF /tmp/example /tmp/"${key}"
```


```bash
# Retrieve from the K-V store, given some key
gzip -dc /tmp/"${key}"
```


```bash
# Verify contents are the same
cat /tmp/example | shasum
gzip -dc /tmp/"${key}" | shasum
```

<br />
<br />
<br />
<br />
<br />

## Graphs
- collection of nodes (vertices) and 0 or more edges that connect nodes
    - v3: solitary node
    - v1: single edge
    - v2: two edges
    - v4: two edges
    - v5: five edges, including a cycle
- undirected graph: the edge "connects" one node to another
    - (v1,v2), (v2,v1)
- directed graph: the edge "points" from one node to another
    - (v1,v2)
- path: finite or infinite sequence of edges that joins a sequence of vertices 
    - v1, v2, v5, v4
- directed acyclic graph ( DAG ): directed graphs with no directed cycles
- rooted in-tree: a DAG where all paths terminate to a single node ( the root )

![]( https://cdn.analyticsvidhya.com/wp-content/uploads/2018/03/graph1.png )


### Operations
- Adding a node
- Adding a directed edge
- Removing a directed edge
- Removing a node

