require 'pry'
require 'yahoofinance'

require_relative 'client_account'
require_relative 'portfolio'
require_relative 'holding'


f = File.new('account_list.txt', 'r')

begin
  accounts = {}
  f.each do |line|
    account_array = line.chomp.split('/ ')
    account = ClientAccount.new(account_array[0], account_array[1], account_array[2], account_array[3], account_array[4])
    accounts[account.name.downcase.to_s + account.address.downcase.to_s] = account
  end
ensure
  f.close
end




def new_account(account_list)
  puts "Please supply the following information for the client..."
  puts "Name:"
  n = gets.chomp.to_s
  puts "Address:"
  a = gets.chomp.to_s
  if account_list.keys.include?((n+a).downcase)
    puts "THIS CLIENT ALREADY EXISTS!!!"
  else
    puts "Telephone:"
    t = gets.chomp.to_s
    puts "Initial cash balance:"
    cb = gets.chomp.to_f
    puts "Are we gramding a credit facility to this client? (y/n)"
    answer = gets.chomp.downcase.to_s[0]
    if answer == 'y'
      puts "How much?"
      cl = gets.chomp.to_f
      account_list[(n +a).downcase] = ClientAccount.new(n, a, t, cb, cl)
    else
      account_list[(n+a).downcase] = ClientAccount.new(n, a, t, cb)
    end
    puts "New account created..."
    puts account_list[(n+a).downcase].to_s_long
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
  puts"(1) List existing clients"
  puts"(2) Create a new client account"
  puts"(3) Add cash to client account"
  puts"(4)    "
  puts"(5)     "
  puts"(6)     "
  response = gets.chomp.to_s.downcase
  case response
    when "1"
      puts
      puts accounts.values.join("\n")
      binding.pry
    when "2"
      new_account(accounts)
    when "3"
      puts









  puts "\nPress <Return> for Main Menu or Q to quit"
  condition = false if gets.chomp.downcase == "q"
  end


end








binding.pry