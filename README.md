# ethereum.rbからgethにつないでコインをやり取りする

## gethの準備

### gethのインストール

https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum を見てね。

### genesisブロックの初期化

```sh
$ geth --datadir ./data init genesis.json
```

### gethの起動

```sh
$ geth --networkid 629 --nodiscover --maxpeers 0 --datadir ./data --mine --minerthreads 1 --rpc --rpcaddr "0.0.0.0" --rpcport 8545 --rpccorsdomain "*" --rpcapi "admin,db,debug,eth,net,personal,web3"
```

## ブロックチェーンとのやりとり

### ユーザ作成

ユーザアカウントをふたり分つくります（june29, antipop）。

```sh
$ bundle exec client.rb init
{"june29"=>
  {"jsonrpc"=>"2.0",
   "id"=>1,
   "result"=>"0x18a7c0730c4a2807db34b3928c32f5a755c7bf2d"},
 "antipop"=>
  {"jsonrpc"=>"2.0",
   "id"=>1,
   "result"=>"0x53b915aa8248440f0f0ffe6f0429edc772c6bd9c"}}
```

上記のアドレス（`result`の中身）を控えておいてください。

### コントラクトをデプロイする

```sh
$ bundle exec client.rb deploy
{"metacoin"=>"0xe77acfd2889c960bebc23d5d5dec491165dc9c1e",
 "convertlib"=>"0x4052e4b91a72763dbed2ecd0d439d4ff2ab7babb"}
```

上記のアドレスを控えておいてください。

### コインを送信する

(まだ)

## Tips

### ethereum.rbのログをみる

JSON-RPCクライアントへのリクエスト時のロギングを有効にしてあるので、以下のようにしてログを見られます。

```sh
$ tail -f /tmp/ethereum_ruby_http.log
```

### アカウントのunlockがだるい

`--unlock`オプションをつけるとよいです。が、最初はアカウントがまだないので、アカウントを作ってからじゃないとだめです。

```sh
$ geth (上記と同じため省略) --unlock 0,1
```
