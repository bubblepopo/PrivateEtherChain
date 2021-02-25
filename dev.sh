
if [[ ! -e "initialize/genesis.json" ]]; then
  echo "先执行step0，创建私链"
  exit
fi

if [[ ! -e "datax/keystore" ]]; then
  geth --datadir datax account new <<< '

'
fi

if [[ ! -e "datax/geth" ]]; then
  geth --datadir datax --networkid 134580 init initialize/genesis.json
fi

enode=`cat data0/nodeinfo`

geth --datadir datax --identity DevTest --nodiscover --maxpeers 0 --networkid 134580 --port 30399 --http --dev --http.corsdomain 'http://127.0.0.1:8080' --http.api "web3,eth,debug,personal,net" --vmdebug --bootnodes "$enode" console

