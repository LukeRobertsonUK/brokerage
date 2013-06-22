require 'pry'
require 'yahoofinance'

require_relative 'client_account'
require_relative 'portfolio'
require_relative 'holding'


f = File.new('account_list.txt', 'r')

begin
  accounts = []
  f.each do |line|
    account_array = line.chomp.split('/ ')
    account = ClientAccount.new(account_array[0], account_array[1], account_array[2], account_array[3].to_f, account_array[4].to_f)
    accounts << account
  end
ensure
  f.close
end


def new_account(account_list)
  condition = true
  puts "Please supply the following information for the client..."
  puts "Name:"
  n = gets.chomp.to_s
  puts "Address:"
  a = gets.chomp.to_s
  account_list.each do |account_object|
    if (account_object.name == n) && (account_object.address == a)
      puts "\nTHIS CLIENT ALREADY EXISTS!!!"
      condition = false
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
      condition = false
  end
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
          accounts[choice].portfolios[t.downcase] = Portfolio.new(n, t)
          puts"\nPortfolio has been created >>>"
          puts accounts[choice].portfolios[t.downcase].to_s
        when "4"
          puts "---------------------------------------------------------------------"
          puts "\nPORTFOLIOS"

          puts "---------------------------------------------------------------------"


  binding.pry






    when "2"
      new_account(accounts)
    when "3"









  end

  puts "\nPress <Return> for Main Menu or Q to quit"
  condition = false if gets.chomp.downcase == "q"



end







end

