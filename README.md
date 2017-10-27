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

こんな感じでトランザクションが帰ってくるので、トランザクションidをDBなりなんなりに記録しておけばよし。

この場合、`transact_and_wait`で同期的に処理したので`mined=true`になっているが、非同期でやる場合にはこれがtrueになるまで裏で待っておく必要がある。

```sh
bundle exec ruby client.rb transfer 0x20e5021e9938ba8ff740701de30aa7e6a9df4d28 10 0xd0902902c4ede68cafa9613f9ddc515598134f8f
#<Ethereum::Transaction:0x007fc523ae4558
 @connection=
  #<Ethereum::HttpClient:0x007fc52496dbb0
   @batch=nil,
   @default_account="0xb1e79f0c8ad57772baf0d35d97973b8c6a0ca822",
   @formatter=#<Ethereum::Formatter:0x007fc52496db88>,
   @gas_limit=4000000,
   @gas_price=22000000000,
   @host="localhost",
   @id=0,
   @log=true,
   @logger=
    #<Logger:0x007fc52496db10
     @default_formatter=
      #<Logger::Formatter:0x007fc52496d9a8 @datetime_format=nil>,
     @formatter=nil,
     @level=0,
     @logdev=
      #<Logger::LogDevice:0x007fc52496d8e0
       @dev=#<File:/tmp/ethereum_ruby_http.log>,
       @filename="/tmp/ethereum_ruby_http.log",
       @mon_count=0,
       @mon_mutex=#<Thread::Mutex:0x007fc52496d868>,
       @mon_owner=nil,
       @shift_age=0,
       @shift_period_suffix="%Y%m%d",
       @shift_size=1048576>,
     @progname=nil>,
   @port=8545,
   @ssl=false,
   @uri=#<URI::HTTP http://localhost:8545>>,
 @id="0xf2e76ae850cec04e14005f92cf6d172794f0d2a5f1243e04b65431ca985ee1cf",
 @input=
  "0x90b98a1100000000000000000000000020e5021e9938ba8ff740701de30aa7e6a9df4d28000000000000000000000000000000000000000000000000000000000000000a",
 @input_parameters=["0x20e5021e9938ba8ff740701de30aa7e6a9df4d28", 10],
 @mined=true>
 ```

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
