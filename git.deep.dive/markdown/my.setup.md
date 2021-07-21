# My setup

I am running docker container on an AWS EC2 instance then ssh'ing into the instance and tunneling port 5150 to forward the Jupyter Lab connection.

---

```bash
# ssh to AWS EC2 instance
ip={ public IP from AWS }
ssh \
    -i ~/.ssh/aws2021.pem \
    -p 22 \
    -L localhost:8080:localhost:5150 \
    ubuntu@${ip}
```

---

```bash
# Launch container instance
mkdir -p ~/git.part-2/
cd ~/git.part-2/
docker \
    run \
    --rm \
    -p 127.0.0.1:5150:8888 \
    -e JUPYTER_ENABLE_LAB=yes \
    -v "${PWD}":/home/jovyan/work \
    --name jupyter-lab \
    jupyter/datascience-notebook:396024a4ddc1 \
    >& /tmp/docker.log &
```

---

```bash
# Customize instance; could be turned into a Dockerfile in the future
## install packages
{ cat <<eof
apt-get update
apt-get install -y ruby tree less file rsync pandoc graphviz
pip install bash_kernel graphviz
python -m bash_kernel.install

eof
} | docker exec -i -u root jupyter-lab /bin/bash

## create aliases file
{ cat <<'eof'
{
  alias cls='clear';
  alias dir='ls -la';
  alias h='history';
  alias more='less -iX';
  export HISTCONTROL=ignoredups:ignorespace;
  export HISTFILESIZE=50000;
  export HISTSIZE=50000;
  export HISTTIMEFORMAT='%t%F %T%t';
  export PAGER='less -iX ';
  export IGNOREEOF=20;
  export PS1='\u@\h: \w\n\$ ';
}
eof
} |
docker exec -i jupyter-lab /bin/bash -c 'cat > ~/.bash_aliases'
```

---

```bash
# Get the token
token=$( grep -m1 token= /tmp/docker.log | cut -d= -f2 )
echo http://localhost:8080/lab?token=${token}
```

---

```bash
# Commands for connecting to instance for interactive session, if needed
## as a regular user
docker exec -it jupyter-lab /bin/bash
## as root
docker exec -it -u root jupyter-lab /bin/bash
```

---

```bash
# Clear all outputs from notebooks and convert to HTML with output
rm -rf html markdown
mkdir -p html markdown
for nb in *.ipynb ; do
    jupyter nbconvert --to notebook --clear-output --inplace ${nb}
    jupyter nbconvert --to html --execute --output html/${nb%.ipynb} ${nb}
    jupyter nbconvert --to markdown --output markdown/${nb%.ipynb} ${nb}
done
```

---
