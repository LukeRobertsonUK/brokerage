require 'pry'
require 'yahoofinance'

require_relative 'client_account'
require_relative 'portfolio'
require_relative 'holding'

include FileUtils


puts `clear`
puts "LOADING DATA..."

# Pull in data from database file
f = File.new('database.txt', 'r')
begin
accounts = []
f.each do |line|
  account_array = line.chomp.split('; ')
  account = ClientAccount.new(account_array[0], account_array[1], account_array[2], account_array[3].to_f, account_array[4].to_f)
  portfolios = []
  if account_array[5]
    array_of_portfolios = account_array[5].split(' <==> ')
    array_of_portfolios.each do |portfolio_element|
      array_within_portfolio = portfolio_element.split(' / ')
      portfolio = Portfolio.new(array_within_portfolio[0], array_within_portfolio[1])
      holdings = {}
    if array_within_portfolio[2]
      array_of_holdings = array_within_portfolio[2].split(' ** ')
      array_of_holdings.each do |holding_element|
        array_within_holding = holding_element.split(' @ ')
        holding = Holding.new(array_within_holding[0], array_within_holding[1].to_f)
        holdings[holding.ticker] = holding
      end
    end
      portfolio.holdings = holdings
      portfolios << portfolio
    end
  end
  account.portfolios = portfolios
  accounts << account
end

ensure
  f.close
end

# Backup database and save to database.txt
def save_data(accounts, filename)
FileUtils.copy(filename, "backup.txt")
save_file = File.new(filename, 'w')
  begin
  accounts.each do |account|
      array_of_portfolio_strings = []
      account.portfolios.each do |portfolio|
        array_of_holding_strings = []
        portfolio.holdings.each_value do |holding|
          holding_string = holding.ticker + " @ " + holding.num_shares.to_s
          array_of_holding_strings << holding_string
          end
          portfolio_holdings_string = array_of_holding_strings.join(" ** ")
          portfolio_string = portfolio.name + " / " + portfolio.type + " / " + portfolio_holdings_string
          array_of_portfolio_strings << portfolio_string
      end
      account_portfolios_string = array_of_portfolio_strings.join(" <==> ")
      account_string = account.name + "; " + account.address + "; " + account.telephone + "; " + account.cash_balance.to_s + "; " + account.credit_limit.to_s + "; " + account_portfolios_string
      save_file.puts account_string
    end

  ensure
  save_file.close

  end
end

def new_account(account_list)
  conditions = true
  puts "Please supply the following information for the client..."
  puts "Name:"
  n = gets.chomp.to_s
  puts "Address:"
  a = gets.chomp.to_s
  account_list.each do |account_object|
    if (account_object.name == n) && (account_object.address == a)
      puts "\nTHIS CLIENT ALREADY EXISTS!!!"
      conditions = false
      puts
    end
  end
  while conditions
    puts "Telephone:"
    t = gets.chomp.to_s
    puts "Initial cash balance:"
    cb = gets.chomp.to_f
    puts "Are we gramding a credit facility to this client? (y/n)"
    answer = gets.chomp.downcase.to_s[0]
    if answer == 'y'
      puts "How much?"
      cl = gets.chomp.to_f
      account_list << ClientAccount.new(n, a, t, cb, cl)
    else
      account_list << ClientAccount.new(n, a, t, cb)
    end
      puts "New account created..."
      puts account_list[-1].to_s_long
      conditions = false
  end
end

def get_quote(account, buy)
  puts "Please supply a ticker:"
  ticker = gets.chomp.upcase.to_s
  puts "#{YahooFinance::get_standard_quotes(ticker)[ticker].name} last traded at #{YahooFinance::get_standard_quotes(ticker)[ticker].lastTrade}"
  if buy
    puts "#{account.name} could purchase up to #{((account.cash_balance + account.credit_limit) / YahooFinance::get_standard_quotes(ticker)[ticker].lastTrade).to_i} shares with available funds."
  end
  return ticker
end

def grab_positive_number(limit = nil)
  puts "Please enter a number:"
  num = gets.chomp.to_f
  if limit
    if num == 0 || num > limit
      print "Try again... "
      grab_positive_number(limit)
    else
      num
    end
else
    if num == 0
      print "Try again... "
      grab_positive_number
    else
      num
    end
  end
end


condition = true
while condition
  puts `clear`
  puts"*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*"
  puts"*$*$*$*$* BROKERAGE APPLICATION *$*$*$*$*"
  puts"*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*"
  puts"\nMAIN MENU"
  puts"(1) List existing clients and display account options"
  puts"(2) Create a new client account"
  response = grab_positive_number(2)
  case response
    when 1
      puts "---------------------------------------------------------------------"
      puts "CLIENT LIST"
        accounts.each_index do |index|
          puts "#{index +1}) #{accounts[index].to_s}"
        end
      puts "---------------------------------------------------------------------"
      choice = (grab_positive_number(accounts.size).to_i) -1
      puts "\nYou have selected the account belonging to #{accounts[choice].name} of #{accounts[choice].address}"
      puts "What would you like to do next?"
      puts "\n(1) Increase cash balance"
      puts "(2) Increase credit limit"
      puts "(3) View holdings by portfolio"
      puts "(4) Create a new portfolio"
      puts "(5) Trade"
        pick = grab_positive_number(5).to_i
        case pick
          when 1
            puts "\nHow much cash would you like to add?:"
            cash_to_add = grab_positive_number
            accounts[choice].increase_balance(cash_to_add)
          when 2
            puts "\nHow much cash would you like to add?:"
            cash_to_add = grab_positive_number
            accounts[choice].increase_credit(cash_to_add)
          when 3
            accounts[choice].display_holdings_by_portfolio
          when 4
            puts "\nWhat would you like to call this portfolio?"
            n = gets.chomp
            puts "\nWhat type of fund is it (pension, regular trading etc)?"
            t = gets.chomp
            accounts[choice].portfolios << Portfolio.new(n, t)
            puts"\nPortfolio has been created >>>"
            puts accounts[choice].portfolios[-1].to_s
          when 5
            if accounts[choice].portfolios.empty?
              puts "\nTHIS CLIENT HAS NO PORTFOLIOS. PLEASE CREATE ONE BEFORE TRYING TO TRADE"
            else
              puts "---------------------------------------------------------------------"
              puts "PORTFOLIOS"
              accounts[choice].list_portfolios
              puts "---------------------------------------------------------------------"
              puts "\nPlease select a portfolio number on which to trade:"
              portfolio_choice = (grab_positive_number(accounts[choice].portfolios.size).to_i) -1
              puts "---------------------------------------------------------------------"
              puts "SELECTED PORTFOLIO CONTAINS THE FOLLOWING HOLDINGS"
              puts "---------------------------------------------------------------------"
              accounts[choice].portfolios[portfolio_choice].display_holdings
              puts "---------------------------------------------------------------------"
              puts "TRADING MENU"
              puts "---------------------------------------------------------------------"
              puts "(1) Get a stock QUOTE"
              puts "(2) Make a stock PURCHASE"
              puts "(3) Make a stock SALE"
              trading_choice = grab_positive_number(3).to_i
              case trading_choice
                when 1
                  get_quote(accounts[choice], true)
                when 2
                  shares_to_buy = get_quote(accounts[choice], true)
                  puts "Purchase Amount"
                  number_to_buy = grab_positive_number.to_i
                  purchase_price = YahooFinance::get_standard_quotes(shares_to_buy)[shares_to_buy].lastTrade
                  if (purchase_price * number_to_buy) <= (accounts[choice].credit_limit + accounts[choice].cash_balance)
                    sufficient_funds = true
                  else
                    puts "TRANSACTION CANCELLED, INSUFFICIENT FUNDS!"
                    sufficient_funds = false
                  end
                  while sufficient_funds
                    if accounts[choice].portfolios[portfolio_choice].holdings.include?(shares_to_buy)
                      accounts[choice].portfolios[portfolio_choice].holdings[shares_to_buy].num_shares += number_to_buy
                      accounts[choice].cash_balance -= purchase_price*number_to_buy
                      puts "CLIENT BUYS #{number_to_buy} shares of #{shares_to_buy} at $#{purchase_price}"
                      puts "UPDATED PORTFOLIO HOLDINGS:"
                      accounts[choice].portfolios[portfolio_choice].display_holdings
                      accounts[choice].to_s_long
                      sufficient_funds = false
                    else
                      accounts[choice].portfolios[portfolio_choice].holdings[shares_to_buy] = Holding.new(shares_to_buy, number_to_buy)
                      accounts[choice].cash_balance -= purchase_price*number_to_buy
                      puts "CLIENT BUYS #{number_to_buy} shares of #{shares_to_buy} at $#{purchase_price}"
                      puts "UPDATED PORTFOLIO HOLDINGS:"
                      accounts[choice].portfolios[portfolio_choice].display_holdings
                      accounts[choice].to_s_long
                      sufficient_funds = false
                    end
                  end
                when 3
                  shares_to_sell = get_quote(accounts[choice], false)
                  sale_price = YahooFinance::get_standard_quotes(shares_to_sell)[shares_to_sell].lastTrade
                  if accounts[choice].portfolios[portfolio_choice].holdings.include?(shares_to_sell)
                    puts "Current holding: #{accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares} shares of #{accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].share_name}"
                    puts "Sale Amount"
                    number_to_sell = grab_positive_number.to_i
                    if number_to_sell > accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares
                      puts "CLIENT CAN'T SELL MORE SHARES THAN THEY OWN!"
                    else
                      accounts[choice].cash_balance += sale_price*number_to_sell
                      puts "CLIENT SELLS #{number_to_sell} shares of #{shares_to_sell} at $#{sale_price}"
                      accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares -= number_to_sell
                      if accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares = 0
                        accounts[choice].portfolios[portfolio_choice].holdings.delete(shares_to_sell)
                      end
                      puts "UPDATED PORTFOLIO HOLDINGS:"
                      accounts[choice].portfolios[portfolio_choice].display_holdings
                      accounts[choice].to_s_long
                    end
                  else
                    puts"CLIENT DOES NOT HAVE ANY SHARES TO SELL!"
                  end
              end
            end
          end
    when 2
      new_account(accounts)
  end
  puts "\nPress <Return> for MAIN MENU or Q to SAVE AND QUIT"
  if gets.chomp.downcase == "q"
        save_data(accounts, "database.txt")
    condition = false
  end
end

