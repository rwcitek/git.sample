```bash
<<'eof' dot -Tpng | display
digraph "the holy hand grenade" {
    # graph configs
    rankdir=LR;
    
    # nodes
    1
    2
    3
    lob
    
    # edges
    1 -> 2
    2 -> 3
    3 -> lob
}
eof
```


```bash
<<'eof' dot -Tpng | display
digraph "the holy hand grenade" {
    # graph configs
    rankdir=LR;
    
    # edges
    1 -> 2
    2 -> 3
    3 -> lob
}
eof
```


```bash
<<'eof' dot -Tpng | display
digraph "the holy hand grenade" {
    # graph configs
    rankdir=RL;
    
    # edges
    1 -> 2 -> 3 -> lob
}
eof
```


```bash
<<'eof' dot -Tpng | display
digraph "the holy hand grenade" {
    # graph configs
    rankdir=RL;
    
    # edges
    lob -> 3 -> 2 -> 1
}
eof
```


```bash

```
