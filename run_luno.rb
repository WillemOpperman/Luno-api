#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'bitx'
  gem 'pry'
end

require 'bitx'
require 'bigdecimal'
require 'bigdecimal/util'

# In a configure block somewhere in your app init:
BitX.configure do |config|
  config.api_key_secret = 'UricF2vqmPnKL8fWMt7JrhS8IPnUt7FEerNuCM9qoAo'
  config.api_key_id = 'ezhh2zass5k96'
  # config.api_key_pin = '1985'
end

class Float
  def round_down n=0
    s = self.to_s
    l = s.index('.') + 1 + n
    s.length <= l ? self : s[0,l].to_f
  end
end

print "#####################################################\n"
print "                        ORDERS                       \n"
print "#####################################################\n"
print "TIME\t|\tTYPE\t\t|\tSTATE\t\t|\tAT\t\t|\tCURRENT\t\t|\tPRICE\t\t|\tVOLUME\t\t|\tDIFF\n"
print "\n"
print "loading....."

def check_order
  while true
    type ||= ''
    order = BitX.list_orders('XBTZAR')

    pending_order = order.detect{|o| o[:completed] == false }

    unless pending_order
      # Chill here for 1min
      sleep 60 if type == 'ASK'

      break
    end

    ticker = BitX.ticker('XBTZAR')
    ask = ticker[:ask].to_f

    type = pending_order[:type]
    state = pending_order[:state]
    limit_price = pending_order[:limit_price].to_f
    limit_volume = pending_order[:limit_volume].to_f
    price = BitX.trades('XBTZAR').first[:price].to_f

    diff = limit_price - ask

    print "\r"
    print "                                                                                                          "
    print "\r"
    print "#{Time.now.utc.strftime("%H:%M:%S")}\t#{type}\t\t\t#{state}\t\t\t#{limit_price}\t\t\t#{ask}\t\t\t#{price}\t\t\t#{limit_volume}\t\t\t#{diff}"

    sleep 0.5
  end
end

def perform_trade
  # # Your Balances
  balance = BitX.balance

  btc = balance.detect{|b| b[:account_id] == "5885140622930799633"}[:balance].to_f
  zar = balance.detect{|b| b[:account_id] == "4094883049486581672"}[:balance].to_f
  puts "XBT: #{btc}"
  puts "ZAR: #{zar}"

  puts
  ticker = BitX.ticker('XBTZAR')
  puts "ASK: #{ask = ticker[:ask].to_f}"
  puts "BID: #{bid = ticker[:bid].to_f}"
  spread = ask - bid
  puts "SPREAD: #{spread}"

  if zar > 1.00
    # require 'pry'
    # binding.pry
    price = bid
    # price = (bid - 50)
    volume = (zar / price).round_down(6)
    # #BitX.post_order(BitX::ORDERTYPE_BID, volume, price, 'XBTZAR')
    BitX.post_order('BID', volume.to_s, price.to_s, 'XBTZAR')
  else
    # require 'pry'
    # binding.pry
    volume = btc.to_s
    # price = ask.to_s
    price = (ask + 50).to_s
    BitX.post_order('ASK', volume, price, 'XBTZAR')
  end
end

while true
  check_order
  print "\r"
  print "                                                                                                          \n"

  sleep 0.5

  perform_trade
  print "                                                                                                          \n"
end

# puts BitX.list_orders('XBTZAR')



#
# ## List your orders trading Bitcoin for Rand
# puts "##########################Orders##########################"
# puts BitX.list_orders 'XBTZAR'
#
# puts 'TRADES'
# puts BitX.trades('XBTZAR').first
#
# while true
#   puts ticker = BitX.ticker('XBTZAR')
#   # puts "ASK: #{ticker[:ask].to_f}"
#   # puts "BID: #{ticker[:bid].to_f}"
#   puts "SPREAD: #{(ticker[:ask] - ticker[:bid]).to_f}"
#
#   # sleep 0.5
# end



#
## Place a new order
## BitX::ORDERTYPE_BID / BitX::ORDERTYPE_ASK
#volume = '0.01'
#price = '10000'
#BitX.post_order(BitX::ORDERTYPE_BID, volume, price, 'XBTZAR')
#
#
##alternatively, if you need to change the api_key during the program you can pass options to the private methods specifying the :api_key_secret and :api_key_id
#BitX.balance_for('XBT', {api_key_secret: 'yoursecretkeyfrombitx', api_key_id: 'yourapiidfrombitx'})