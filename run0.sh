
if [[ ! -e "initialize/genesis.json" ]]; then
  echo "先执行step0，创建私链"
  exit
fi

if [[ ! -e "data0/keystore" ]]; then
  geth --datadir data0 account new <<< '123456
123456
'
fi

if [[ ! -e "data0/geth" ]]; then
  geth --datadir data0 --networkid 134580 init initialize/genesis.json
fi

geth --datadir data0 --identity ZhaXiPrivateChain001 --maxpeers 5 --networkid 134580 --port 30300 console <<< '' 2>&1 | grep 'Started P2P' | awk -F '=' '{print $2}' > data0/nodeinfo

geth --datadir data0 --identity ZhaXiPrivateChain001 --maxpeers 5 --networkid 134580 --port 30300  console

