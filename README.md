# 欢迎来到TocaIsland NFT 合约代码仓库

并非最佳实践，如果你有更好的建议或者代码优化，请提交 Issue 或者 PR。

## 技术

- 使用 ERC721A 协议节约 mint 多个 NFT 的 Gas fee
- 使用 hardhat 用来开发、测试和部署

## 跑起来项目

运行下面命令：

```
git clone https://github.com/JetCyC/galaxyz-a-contract.git
cd galaxyz-a-contract
npm install
```

将 .env.sample 复制改名为 .env 然后将里面内容进行修改。

为了方便测试，你可以使用TocaIsland的 ipfs 地址作为测试：

- 生产环境：ipfs://Qmc6RQemKeyevPSFqKtisCWrhGnZXY5q4cFaTt3MwnHEaG/

## 使用步骤

1. 编写合约代码。完成 contract 代码编写，在 contracts 文件夹下创建你的 contract 文件，比如：TOCABO.sol。
2. 编写测试代码。为保证代码质量，可以编写单元测试代码，本项目使用的是 [chai](https://www.chaijs.com/) 断言库，你也可以选择其他的。
3. 编写部署脚本。在 scripts 目录下创建你的部署的脚本文件，后面用来部署合约到对应网络。
4. 部署到本地或者 Rinkeby 测试网络。OpenSea 测试版支持 Rinkeby 所以，你最好使用 Rinkeby 来测试。部署的时候，确保你的部署钱包有足够的 Rinkeby ETH，可以在这里领取 <https://faucets.chain.link/>。
5. Verify 验证测试网络合约。验证可以将你的合约代码开源。
6. 测试完成后，修改配置部署到 Mainnet 主网。此时的 ETH 是真金白银，可能需要等待一段时间，大概 0.2 ETH 左右。
7. Verify 验证主网合约。
8. 设置对应合约状态，开启 Mint 等。

### 编译命令

`npx hardhat compile`

编译之后，生成的 ABI 将会存放在这里 `./artifacts/contracts/TOCABO.sol/TOCABO.json`。

### 部署命令（指定对应网络）

`npm run deploy:{rinkeby}` 或者 `npx hardhat run {scripts/deploy.js} --network {rinkeby}`

> 我们在 package.json scripts 里已经帮大家分好了不同网络的部署命令，可以修改对应参数和变量后 npm run 对应的命令。

部署成功后，你将会得到一个钱包地址，去到对应网络的 etherscan（例如 Rinkeby 测试网络：<https://rinkeby.etherscan.io/>）搜索这个钱包地址，你将会看到你的合约详情，但是此时的合约还不能进行读写操作，需要进行验证开源后，才可以在 etherscan 上面直接设置合约信息。

### 验证

`npx hardhat verify {contract} '{ipfs}' --network {rinkeby}` 或修改 package.json 之后执行 `npm run verify:{rinkeby}`

> contract 是你部署合约的地址，ipfs 是 baseURI，然后也要设置对应的网络。
> 同样的，我们在 package.json scripts 里已经帮大家分好了不同网络的部署命令，可以直接 npm run 对应的命令。

