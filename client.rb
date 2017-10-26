#!/usr/bin/env ruby

require 'ethereum'
require 'pp'

command  = ARGV.first
client   = Ethereum::HttpClient.new('http://localhost:8545', true)
password = "password"

case command.to_sym
when :init then
  june29  = client.personal_new_account(password)
  antipop = client.personal_new_account(password)

  pp "june29"  => june29, "antipop" => antipop
when :deploy then
  base = client.eth_accounts["result"].first
  client.personal_unlock_account(base, password)

  convertlib = Ethereum::Contract.create(
    client: client,
    file:   "vendor/truffle-init-default/contracts/ConvertLib.sol",
  )
  convertlib_address = convertlib.deploy_and_wait

  metacoin = Ethereum::Contract.create(
    client: client,
    file:   "vendor/truffle-init-default/contracts/MetaCoin.sol",
  )
  metacoin_address = metacoin.deploy_and_wait
  
  pp "metacoin" => metacoin_address, "convertlib" => convertlib_address
when :transfer then
  base = client.eth_accounts["result"].first
  client.personal_unlock_account(base, password)

  to_address, amount, contract_address = ARGV[1..3]

  contract = Ethereum::Contract.create(
    client:  client,
    file:    "vendor/truffle-init-default/contracts/MetaCoin.sol",
    address: contract_address,
  )
  pp contract.transact_and_wait.send_coin(to_address, amount)
else
  puts "command not found"
  exit(1)
end
