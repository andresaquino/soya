#!/bin/sh 
# vim: set ts=2 sw=2 sts=2 si ai: 

# install.sh -- instalar soya en el directorio
# =-=
# Developer
# Andres Aquino Morales <andres.aquino@gmail.com>
# 


mkdir -p ~/bin
mkdir -p ~/manuals/man1

# respaldar setup actual
cd ~
echo "Migrando configuraciones"
[ -d ~/soya ] && cp -rp ~/soya/setup/*.conf ~/soya.git/setup/ 
cd ~/soya.git/setup/
for ap in *.conf
do
	ln -sf ../soya.sh ${ap%.conf}.start
	ln -sf ../soya.sh ${ap%.conf}.stop
	ln -sf ../soya.sh ${ap%.conf}.check
	ln -sf ../soya.sh ${ap%.conf}.logson
	ln -sf ../soya.sh ${ap%.conf}.logsoff
	ln -sf ../soya.sh ${ap%.conf}.syslogson
	ln -sf ../soya.sh ${ap%.conf}.syslogsoff
	ln -sf ../soya.sh ${ap%.conf}.dblogson
	ln -sf ../soya.sh ${ap%.conf}.dblogsoff
done

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

ln -sf ~/soya/soyarc ~/.soyarc
ln -sf ~/soya/screenrc ~/.screenrc

chmod 0640 ~/soya/install.sh 
chmod 0750 ~/soya/soya.sh

# establecer nuevo path
PATH=$HOME/bin:$PATH

#
