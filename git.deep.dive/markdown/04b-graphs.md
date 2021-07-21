# Graphs with graphviz

From https://h1ros.github.io/posts/introduction-to-graphviz-in-jupyter-notebook/

## Basic Usage
A graph is a collection of zero or more nodes ( vertices ) and zero or more edges that connect the nodes.  All nodes have an unique identifier (ID) and optionally some metadata.  

Edges can be undirected or directed.  We'll be using only directed edges.


```python
from graphviz import Digraph
```

### Graph with Two Nodes


```python
# Create Digraph object
dot = Digraph()

# Add nodes 1 and 2
dot.node('1', "ID: 1")
dot.node('2', "ID: 2")

# Visualize the graph
dot
```

### A Two-node Directed Graph


```python
# Create Digraph object
dot = Digraph()
dot.graph_attr['rankdir'] = 'LR'

# Add nodes 1 and 2
dot.node('1', "ID: 1")
dot.node('2', "ID: 2")

# Add edge between 1 and 2
dot.edges(['12'])

# Visualize the graph
dot
```

## Directed Graph with Cycles


```python
# Create Digraph object
dot = Digraph()

# Left to right, instead top down
dot.graph_attr['rankdir'] = 'LR'

# Add nodes 1 and 2
dot.node('1', "ID: 1")
dot.node('2', "ID: 2")

# Add edge between 1 and 2
dot.edges(['12', '11', '21', '22'])

# Visualize the graph
dot
```

## Right to Left


```python
# Create a directed graph object
dot = Digraph()

# Left to right, instead top down
dot.graph_attr['rankdir'] = 'RL'

# Add nodes 1 and 2
dot.node('1', "ID: sha\nmetadata: something")
dot.node('2', "world")

# Add edge between 1 and 2
dot.edges(['21'])

# Visualize the graph
dot
```


```python
print(dot.source)
```

## Raw DOT


```python
from graphviz import Source
src = Source('''
    digraph "the holy hand grenade" {
        rankdir=LR;
        1
        2
        3
        lob
        1 -> 2
        2 -> 3
        3 -> lob
    }
''')
src
```


```python
from graphviz import Source
src = Source('''
    digraph "the holy hand grenade" {
        rankdir=RL;
        1
        2
        3
        lob
        2 -> 1
        3 -> 2
        lob -> 3
    }
''')
src
```


```python

```

## A Tree


```python
# Create Digraph object
dot = Digraph()
dot.graph_attr['rankdir'] = 'LR'

# Add nodes
dot.node('1')
dot.node('3')
dot.node('2')
dot.node('5')

# Add edges
dot.edges(['12', '13', '35'])

# Visualize the graph
dot

```


```python

```
