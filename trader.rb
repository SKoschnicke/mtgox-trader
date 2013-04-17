require 'rubygems'
require 'mtgox'

require './config.rb'
STDOUT.sync = true

spread = ARGV[0].to_f # there must be two dollar difference to take action
next_action = {:action => :buy, :price => MtGox.ticker.buy, :last_fee => 0.0}

start_money = 14.0
fee = 0.006

money = start_money
btc = 0.0

while true do
  begin
      ticker = MtGox.ticker
      if next_action[:action] == :buy and ticker.buy <= next_action[:price] - next_action[:last_fee]
        puts "buying for #{ticker.buy}"
        btc = (money - (money*fee)) / ticker.buy
        next_action = {:action => :sell, :price => ticker.buy + spread, :last_fee => money * fee / btc}
        money = 0.0
        puts "next target is selling for #{next_action[:price] + next_action[:last_fee]}"
      elsif next_action[:action] == :sell and ticker.sell >= next_action[:price] + next_action[:last_fee]
        puts "selling for #{ticker.sell}"
        money = (btc - (btc * fee)) * ticker.sell
        next_action = {:action => :buy, :price => ticker.sell - spread, :last_fee => btc * fee / money}
        btc = 0.0
        puts "next target is buying for #{next_action[:price] - next_action[:last_fee]}"
      end

      if next_action[:action] == :buy
        puts "buy price is #{ticker.buy}"
      else
        puts "sell price is #{ticker.sell}"
      end
      puts "Balance: #{btc} BTC, #{money} USD, #{(money + (btc*ticker.sell) - start_money)/start_money * 100.0}%"
      sleep 10
  rescue
      puts "got exception"
  end
end

=begin
puts "Current balance: #{MtGox.balance}"
price = MtGox.max_bid.price
puts "can sell for #{price}"
value = 0.000001
puts MtGox.trades.inspect
res = MtGox.sell! value, price
puts "sell: #{res.inspect}"
puts "Orders: #{MtGox.orders.inspect}"
sleep 2
puts "Balance now: #{MtGox.balance}"
=end
