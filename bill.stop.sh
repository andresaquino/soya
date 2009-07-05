screen -S BILL0 -p 0 -X stuff "$(printf '%b' "exit\015")"
sleep 8
screen -S BILL0 -p 0 -X quit > /dev/null 2>&1 
screen -S BILL1 -p 0 -X stuff "$(printf '%b' "exit\015")"
sleep 8
screen -S BILL1 -p 0 -X quit > /dev/null 2>&1
screen -S BILL2 -p 0 -X stuff "$(printf '%b' "exit\015")"
sleep 8
screen -S BILL2 -p 0 -X quit > /dev/null 2>&1
screen -S BILL3 -p 0 -X stuff "$(printf '%b' "exit\015")"
sleep 8
screen -S BILL3 -p 0 -X quit > /dev/null 2>&1
screen -S BILL4 -p 0 -X stuff "$(printf '%b' "exit\015")"
sleep 8
screen -S BILL4 -p 0 -X quit > /dev/null 2>&1
screen -S BILL5 -p 0 -X stuff "$(printf '%b' "exit\015")"
sleep 8
screen -S BILL5 -p 0 -X quit > /dev/null 2>&1


echo "BILL process finalized"












