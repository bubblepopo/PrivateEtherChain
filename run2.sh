
if [[ ! -e "initialize/genesis.json" ]]; then
  echo "先执行step0，创建私链"
  exit
fi

if [[ ! -e "data2/keystore" ]]; then
  geth --datadir data2 account new <<< '$trong+P@ssW0rd=Qiang2Mi4Ma3?
$trong+P@ssW0rd=Qiang2Mi4Ma3?
'
fi

if [[ ! -e "data2/geth" ]]; then
  geth --datadir data2 --networkid 134580 init initialize/genesis.json
fi

enode=`cat data0/nodeinfo`

geth --datadir data2 --identity ZhaXi002 --maxpeers 5 --networkid 134580 --port 30302 console <<< '' 2>&1 | grep 'Started P2P' | awk -F '=' '{print $2}' > data2/nodeinfo

geth --datadir data2 --identity ZhaXi002 --maxpeers 5 --networkid 134580 --port 30302 --bootnodes "$enode" console
