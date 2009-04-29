#!/bin/sh

echo " * * * * * * * * * * * * * * * * Bajando Modulos GMD"
/bscs/bscuat/bin/stop_md ALL
sleep 5

echo " * * * * * * * * * * * * * * * * Levantando GMD"
start_gmd

