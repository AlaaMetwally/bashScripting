#!/bin/bash
file=~/.bashrc

[[ ! -d myDB ]] && mkdir myDB 
grep -qF -- "alias mydb='bash $HOME/bashScripting/mydb.sh'" "$file" || echo "alias mydb='bash $HOME/bashScripting/mydb.sh'" >> ~/.bashrc
. ~/.bashrc
