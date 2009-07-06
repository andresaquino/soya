#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# install.sh -- instalar soya en el directorio
# --------------------------------------------------------------------
# (c) 2008 NEXTEL DE MEXICO
# 
# César Andrés Aquino <cesar.aquino@nextel.com.mx>

mkdir -p ~/bin
[ -d ~/soya.git ] && mv ~/soya.git ~/soya
chmod 0750 ~/soya/soya.sh
ln -sf ~/soya/soya.sh ~/bin/soya
PATH=$HOME/bin:$PATH
echo "Set this:\n${PATH}"

#
