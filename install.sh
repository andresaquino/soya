#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# install.sh -- instalar soya en el directorio
# --------------------------------------------------------------------
# (c) 2008 NEXTEL DE MEXICO
# 
# César Andrés Aquino <cesar.aquino@nextel.com.mx>

mkdir -p ~/bin
# si existe, moverlo
[ -d ~/soya.old ] && rm -fr ~/soya.old
[ -d ~/soya ] && mv ~/soya ~/soya.old
[ -d ~/soya.git ] && mv ~/soya.git ~/soya
[ -d ~/soya.oldi/setup ] && cp -rp ~/soya.old/setup/* ~/soya/setup/ 
chmod 0750 ~/soya/soya.sh
ln -sf ~/soya/soya.sh ~/bin/soya
PATH=$HOME/bin:$PATH

#
