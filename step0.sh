
# 强行终止 geth 进程，可能导致区块链损坏，可以删除 ~/Library/Ethash 目录后，重新配置

#清除之前的测试
# geth --datadir "./data0" removedb
#彻底清除
# rm -rf "./data0"

#生成创世区块配置
if [[ ! -e "initialize/genesis.json" ]]; then
echo '{
  "config": {
    "chainId": 99,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "ethash": {}
  },
  "nonce": "0x0",
  "timestamp": "0x5d5cdc87",
  "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0x47b760",
  "difficulty": "0x80000",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
    "0000000000000000000000000000000000000000": {
      "balance": "0x1"
    }
  },
  "number": "0x0",
  "gasUsed": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}' > initialize/genesis.json
# chainId: 指定了独立的区块链网络ID。网络ID在连接到其他节点的时候会用到，以太坊公网的网络ID是 1，为了不与公有链网络冲突，运行私有链节点的时候要指定自己的网络ID。不同ID网络的节点无法相互连接。
# HomesteadBlock:	当设置为0表示使用Homestead发布该链。
# nonce:	一个64位随机数，用于挖矿，注意它和mixhash的设置需要满足以太坊的Yellow paper, 4.3.4. Block Header Validity, (44)章节所描述的条件。
# mixhash: 与nonce配合用于挖矿，由上一个区块的一部分生成的hash。注意它和nonce的设置需要满足以太坊的Yellow paper, 4.3.4. Block Header Validity, (44)章节所描述的条件。
# difficulty: 设置设置当前区块的难度，值越大挖矿就越难。
# alloc: 用来预置账号以及账号的以太币数量。
# coinbase: 矿工账号
# timestamp: 设置创世块的时间戳
# parentHash: 上一个区块的hash，创世块就为0
# extraData: 附加信息,自己可以填写任意信息
# gasLimit: 该值设置对GAS的消耗总量限制，用来限制区块能包含的交易信息总和
fi

#生成创世区块
if [[ ! -e "data0/geth" ]]; then
geth --datadir "./data0" init initialize/genesis.json

#启动私链
# --datadir "/home/TestChain1" 私有链存放路径（最好跟公有链路径不同）
# --identity “TestnetMainNode" 用来标识你的节点的，方便在一大群节点中识别出自己的节点
# --nodiscover 使用这个参数，你的节点就不会被其他人发现，除非手动添加你的节点。否则，就只有一个被无意添加到一个陌生区块链上的机会，那就是跟你有相同的genesis文件和networkID。
# --maxpeers 0 如果你不想有人连上你的测试链，就用maxpeers 0。或者，你可以调整参数，当你确切的知道有几个节点要连接上来的时候。
# --port "30303" 网络监听端口，用来和其他节点手动连接
geth --datadir "./data0" --identity ZhaXiPrivateChain001 --nodiscover --maxpeers 0 --networkid 134580 console <<< '
"在 geth console 下执行的命令脚本:"
web3

"创建用户0:"
personal.newAccount(123456)
"创建用户1:"
personal.newAccount(123456)

"当前用户:"
eth.accounts

"查看账户的余额:"
eth.getBalance(eth.coinbase)

"查看当前区块总数:"
eth.blockNumber

"开始挖矿，等待挖到一个区块之后停止挖矿(第一次挖矿启动时间比较长):"
miner.start(1);admin.sleepBlocks(1);miner.stop();

"解锁转出账户(输入密码):"
personal.unlockAccount(eth.accounts[0])
123456

"转账:"
eth.sendTransaction({from: eth.coinbase, to: eth.accounts[1], value: web3.toWei(0.1,"ether")})

"查看交易状态:"
txpool.status

"要使交易被处理，必须要挖矿。启动挖矿，然后等待挖到一个区块之后就停止挖矿:"
miner.start(1);admin.sleepBlocks(1);miner.stop();

"查看交易状态:"
txpool.status

"查看转账结果:"
web3.fromWei(eth.getBalance(eth.accounts[1]),'ether')

"查看当前区块总数:"
eth.blockNumber

"通过区块号查看区块:"
eth.getBlock(1)
'
fi

./run0.sh
#启动私链
# --datadir "/home/TestChain1" 私有链存放路径（最好跟公有链路径不同）
# --identity “TestnetMainNode" 用来标识你的节点的，方便在一大群节点中识别出自己的节点
# --nodiscover 使用这个参数，你的节点就不会被其他人发现，除非手动添加你的节点。否则，就只有一个被无意添加到一个陌生区块链上的机会，那就是跟你有相同的genesis文件和networkID。
# --maxpeers 0 如果你不想有人连上你的测试链，就用maxpeers 0。或者，你可以调整参数，当你确切的知道有几个节点要连接上来的时候。
# --port "30303" 网络监听端口，用来和其他节点手动连接
#geth --datadir "./data0" --identity ZhaXiPrivateChain001 --maxpeers 5 --networkid 134580 console

# "通过交易hash查看交易:"
# eth.getTransaction("0x94a9bacda11313ddce58d1a47555aaf59ab5614bb3c8eb4b423f46464b8507f9")
# {
#   blockHash: "0x5d410b4147a06bf4e0cfc27ca84f9854f6e879cd254185ef811a81f799ed0eb6",
#   blockNumber: 69,
#   from: "0x0416f04c403099184689990674f5b4259dc46bd8",
#   gas: 90000,
#   gasPrice: 18000000000,
#   hash: "0x94a9bacda11313ddce58d1a47555aaf59ab5614bb3c8eb4b423f46464b8507f9",
#   input: "0x",
#   nonce: 0,
#   r: "0xbb46294248e5c31ae6d371fd5a6dedbad4d346383b5eff94066e69e927c9cb5e",
#   s: "0x4ece28bd523c97ac2a7089693a217bc0092a482c27d50a435dcd2421ec66b5e7",
#   to: "0xb89bf2a212484ef9f1bd09efcd57cf37dbb1e52f",
#   transactionIndex: 0,
#   v: "0x37",
#   value: 5000000000000000000
# }

#通过区块号查看区块：
# eth.getBlock(33)
# {
#   difficulty: 133056,
#   extraData: "0xd883010703846765746887676f312e392e328664617277696e",
#   gasLimit: 3244382,
#   gasUsed: 0,
#   hash: "0x198ec33f48858979195c6bfab631cd516a10ff5473f26598398c9d445a0e2d01",
#   logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
#   miner: "0x0416f04c403099184689990674f5b4259dc46bd8",
#   mixHash: "0xe43e60cbbb0063e712a4c3900808deff5ef582b690c17ecadbbb32dd44bc7956",
#   nonce: "0x3dabcace6101360d",
#   number: 33,
#   parentHash: "0x922551d1ea1f63845b2662370f1334eb9b7554605985a93121cd32d12f5950ae",
#   receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
#   sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
#   size: 536,
#   stateRoot: "0x24bd5ceedf75a25e8e065cf9553e097e405ef4d6cf38ddf64f621244aa229898",
#   timestamp: 1519718647,
#   totalDifficulty: 4488192,
#   transactions: [],
#   transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
#   uncles: []
# }

