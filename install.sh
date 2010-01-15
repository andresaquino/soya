#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# install.sh -- instalar soya en el directorio
# =-=
# (c) 2008, 2009 Nextel de Mexico
# Andrés Aquino Morales <andres.aquino@gmail.com>
# 

mkdir -p ~/bin
mkdir -p ~/manuals/man1

# respaldar setup actual
cd ~
echo "Migrando configuraciones"
[ -d ~/soya ] && cp -rp ~/soya/setup/*.conf ~/soya.git/setup/ 
cd ~/soya.git/setup/
for ap in *.conf do; ln -sf ../soya.sh ${ap%.conf};done

cd ~
# mover actual como backup
echo "Se respaldo la anterior configuracion en $HOME/soya.old"
[ -d ~/soya.old ] && rm -fr ~/soya.old
[ -d ~/soya ] && mv ~/soya ~/soya.old

# instalar nuevo componente
[ -d ~/soya.git ] && mv ~/soya.git ~/soya

# copiar manual
echo "Siempre podras consultar el manual con: man soya"
cp ~/soya/man1/soya.1 ~/manuals/man1/

# establecer nuevo path
PATH=$HOME/bin:$PATH

#
