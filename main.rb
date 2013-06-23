require 'pry'
require 'yahoofinance'

require_relative 'client_account'
require_relative 'portfolio'
require_relative 'holding'


# Pull in data from database file
f = File.new('database.txt', 'r')
begin
accounts = []
f.each do |line|
  account_array = line.chomp.split('; ')
  account = ClientAccount.new(account_array[0], account_array[1], account_array[2], account_array[3].to_f, account_array[4].to_f)
  portfolios = []
  array_of_portfolios = account_array[5].split(' <==> ')
  array_of_portfolios.each do |portfolio_element|
    array_within_portfolio = portfolio_element.split(' / ')
    portfolio = Portfolio.new(array_within_portfolio[0], array_within_portfolio[1])
    holdings = {}
    # binding.pry
    array_of_holdings = array_within_portfolio[2].split(' ** ')
    array_of_holdings.each do |holding_element|
      array_within_holding = holding_element.split(' @ ')
      holding = Holding.new(array_within_holding[0], array_within_holding[1])
      holdings[holding.ticker] = holding
  end
    portfolio.holdings = holdings
    portfolios << portfolio
  end
  account.portfolios = portfolios
  accounts << account
end

ensure
  f.close
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
  while condition
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

def get_quote(account)
  puts "Please supply a ticker:"
  ticker = gets.chomp.upcase.to_s
  puts "#{YahooFinance::get_standard_quotes(ticker)[ticker].name} last traded at #{YahooFinance::get_standard_quotes(ticker)[ticker].lastTrade}"
  puts "You could purchase up to #{((account.cash_balance + account.credit_limit) / YahooFinance::get_standard_quotes(ticker)[ticker].lastTrade).to_i} shares with your available funds."
  return ticker
end


condition = true
while condition
  puts `clear`
  puts"*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*"
  puts"*$*$*$*$* BROKERAGE APPLICATION *$*$*$*$*"
  puts"*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*$*"
  puts"\nMAIN MENU"
  puts"\nAccount Administration"
  puts"(1) List existing clients and display account options"
  puts"(2) Create a new client account"
  puts"(3) Options for individual client accounts"
  puts"(4)    "
  puts"(5)     "
  puts"(6)     "
  response = gets.chomp.to_s.downcase
  case response
    when "1"
      puts "---------------------------------------------------------------------"
      puts "CLIENT LIST"
        accounts.each_index do |index|
          puts "#{index +1}) #{accounts[index].to_s}"
        end
      puts "---------------------------------------------------------------------"
      puts "\nEnter a client account number for further options:"
      choice = (gets.chomp.to_i) -1
      puts "\nYou have selected the account belonging to #{accounts[choice].name} of #{accounts[choice].address}"
      puts "What would you like to do next?"
      puts "(1) Increase cash balance"
      puts "(2) Increase credit limit"
      puts "(3) Create a new portfolio"
      puts "(4) Trade"
      pick = gets.chomp.downcase.to_s
      case pick
        when "1"
          puts "\nHow much cash would you like to add?:"
          cash_to_add = gets.chomp.to_f
          accounts[choice].increase_balance(cash_to_add)
        when "2"
          puts "\nHow much cash would you like to add?:"
          cash_to_add = gets.chomp.to_f
          accounts[choice].increase_credit(cash_to_add)
        when "3"
          puts "\nWhat would you like to call this portfolio?"
          n = gets.chomp
          puts "\nWhat type of fund is it (pension, regular trading etc)?"
          t = gets.chomp
          accounts[choice].portfolios << Portfolio.new(n, t)
          puts"\nPortfolio has been created >>>"
          puts accounts[choice].portfolios[-1].to_s
        when "4"
          if accounts[choice].portfolios.empty?
            puts "\nTHIS CLIENT HAS NO PORTFOLIOS. PLEASE CREATE ONE BEFORE TRYING TO TRADE"
          else
            puts "---------------------------------------------------------------------"
            puts "PORTFOLIOS"
            accounts[choice].list_portfolios
            puts "---------------------------------------------------------------------"
            puts "\nPlease select a portfolio number on which to trade:"
            portfolio_choice = (gets.chomp.to_i) -1
            puts "---------------------------------------------------------------------"
            puts "TRADING MENU FOR #{accounts[choice].portfolios[portfolio_choice].to_s}"
            puts "---------------------------------------------------------------------"
            puts "(1) Get a stock quote"
            puts "(2) Make a stock PURCHASE"
            puts "(3) Make a stock SALE"
            puts "(4) "
            trading_choice = gets.chomp.downcase.to_s
            case trading_choice
              when '1'
                get_quote(accounts[choice])
              when "2"
                shares_to_buy = get_quote(accounts[choice])
                puts "How many shares would the client like to buy?"
                number_to_buy = gets.chomp.to_i
                purchase_price = YahooFinance::get_standard_quotes(shares_to_buy)[shares_to_buy].lastTrade
                if (purchase_price * number_to_buy) <= (accounts[choice].credit_limit + accounts[choice].cash_balance)
                  sufficient_funds = true
                else
                  puts "You do not have sufficient funds to complete this transaction!"
                  sufficient_funds = false
                end
                while sufficient_funds
                  if accounts[choice].portfolios[portfolio_choice].holdings.include?(shares_to_buy)
                    accounts[choice].portfolios[portfolio_choice].holdings[shares_to_buy].num_shares += number_to_buy
                    accounts[choice].cash_balance -= purchase_price*number_to_buy
                    puts "CLIENT BUYS #{number_to_buy} shares of #{shares_to_buy} at $#{purchase_price}"
                    sufficient_funds = false
                  else
                    accounts[choice].portfolios[portfolio_choice].holdings[shares_to_buy] = Holding.new(shares_to_buy, number_to_buy)
                    accounts[choice].cash_balance -= purchase_price*number_to_buy
                    puts "CLIENT BUYS #{number_to_buy} shares of #{shares_to_buy} at $#{purchase_price}"
                    sufficient_funds = false
                  end
                end
              when "3"
                shares_to_sell = get_quote(accounts[choice])
                sale_price = YahooFinance::get_standard_quotes(shares_to_buy)[shares_to_buy].lastTrade
                if accounts[choice].portfolios[portfolio_choice].holdings.include?(shares_to_sell)
          binding.pry

                  puts "You currently hold #{accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares} shares of #{accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].share_name}"
                  puts "How many would you like to sell?"
                  number_to_sell = gets.chomp.to_i
                  if number_to_sell > accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares
                    puts "YOU CAN'T SELL MORE SHARES THAN YOU OWN!"
                  else
                    accounts[choice].cash_balance += sale_price*number_to_sell
                    puts "CLIENT SELLS #{number_to_sell} shares of #{shares_to_sell} at $#{sale_price}"
                    accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares -= number_to_sell
                    if accounts[choice].portfolios[portfolio_choice].holdings[shares_to_sell].num_shares = 0
                      accounts[choice].portfolios[portfolio_choice].holdings.delete(shares_to_sell)
                    end
                  end
                end





            end
          end

  binding.pry






    when "2"
      new_account(accounts)
    when "3"









  end




end


  puts "\nPress <Return> for Main Menu or Q to quit"
  condition = false if gets.chomp.downcase == "q"





end

