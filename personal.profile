#!/bin/sh
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# personal.profile -- profile unix de aplicaciones
# --------------------------------------------------------------------
# (c) 2008 NEXTEL DE MEXICO
# 
# César Andrés Aquino <cesar.aquino@nextel.com.mx>

# input mode
set -o vi

# terminal line settings
stty erase '^?'
stty intr '^C' 
stty kill '^U' 
stty stop '^S'
stty susp '^Z'
stty werase '^W'

# command line _eye candy_
CCLEAR="\033[00m"; CWHITE="\033[01;37m"
CRED="\033[01;31m"; CYELLOW="\033[01;33m"
CBLUE="\033[01;34m"; CGRAY="\033[01;30m"

# functions
java15 () {
   PATH=/opt/java1.5/bin:${LOCALPATH}
}

java14 () {
   PATH=/opt/java1.4/bin:${LOCALPATH}
}

java13 () {
   PATH=/opt/java1.3/bin:${LOCALPATH}
}

java12 () {
   PATH=/opt/java1.2/bin:${LOCALPATH}
}

newstyle () {
   # command line _eye candy_
   CCLEAR="\033[00m"; CWHITE="\033[01;37m"
   CRED="\033[01;31m"; CYELLOW="\033[01;33m"
   CBLUE="\033[01;34m"; CGRAY="\033[01;30m"

   export PS1="$(echo "${CBLUE}${USER}${CWHITE}@${IPLN}(${CRED}${HOST}${CWHITE})${CCLEAR}") \${PWD##*/} $ "
   export PS2="  -> "
}

oldstyle () {
   export PS1="$(echo "\n${CGRAY}${IPLN}(${HOST})${CCLEAR}:${CWHITE}\${PWD}\n${CBLUE}${USER}${CCLEAR}$> ")"
   export PS2=" > "
}

#TODO
# esto en HPUX se apendeja, probrecito sistema mierda:
# cuando encolas dos procesos en una llamada se atonteja y se tarda en responder
# JUAR JUAR JUAR JUAR ! ! ! !
search () {
   STRING=$1
   FORE=`tput smso`
   UNDR=`tput smul`
   NORM=`tput sgr0`
   
   grep ${STRING} | sed -e "s/${STRING}/${FORE}${STRING}${NORM}/g" | grep -v sed
}

# PATH
# para ejecución de aplicaciones
LOCALPATH=$HOME/bin:/usr/sbin:$PATH:/usr/local/bin:.

# common alias
alias ls='ls -F'
alias ll='ls -l'
alias la='ll -a'
alias lt='la -t'
alias lr='lt -r'
alias pw='pwd'
alias domains='cd ~/bea/user_projects/domains'

# Commands
PING=`whereis ping | awk '{print $2}'`

# terminal type
export EDITOR=vi
export TERM="xterm"
# history file
export HISTSIZE=300
export HISTCONTROL=ignoredups
# otros
export PATH=${LOCALPATH}
export HOST=`hostname | tr "[:upper:]" "[:lower:]" | sed -e "s/m.*hp//g"`
export IPLN=`${PING} $(hostname) -c1 | awk '/bytes from/{gsub(":","",$4);print $4}' > /dev/null 2>&1`
export MANPATH=$HOME/monopse:$MANPATH
# 
[ "$SSH_CONNECTION" != "" ] && IPLN=`echo $SSH_CONNECTION | cut -f3 -d" "`

# Cursor and profile
oldstyle

