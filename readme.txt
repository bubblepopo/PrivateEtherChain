
0. 
   安装以太坊区块链控制台 geth
      brew tap ethereum/ethereum
      brew install ethereum
   安装Solidity编译器
      brew install solidity
   安装集成开发环境 Remix IDE + remixd
      docker pull remixproject/remix-ide:remix_live
      npm install -g remixd
   
   Mac系统下，如果npm install过程中需要XCode Command Line Tool（错误代码：gyp: No Xcode or CLT version detected!），可执行下列操作解决：
      sudo rm -rf $(xcode-select -p)
      sudo xcode-select --install

1. 创建私链环境
   ./step0.sh

2. 启动开发模式
   ./dev.sh

3. 启动开发环境
   ./remix.sh

4. 合约开发测试
   http://127.0.0.1:8080










