require 'rubygems'
require 'mtgox'

require './config.rb'

=begin
while true do
  puts MtGox.ticker.sell
  sleep 2
end
=end
puts "Current balance: #{MtGox.balance}"
price = MtGox.ticker.sell
puts "can sell for #{price}"
value = 0.0000001
res = MtGox.sell! value, price
puts "sell: #{res.inspect}"
puts "Orders: #{MtGox.orders.inspect}"
sleep 2
puts "Balance now: #{MtGox.balance}"
