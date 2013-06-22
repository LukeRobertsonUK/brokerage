class ClientAccount
  attr_accessor :name, :address, :telephone, :cash_balance, :credit_limit, :portfolios

  def initialize(name, address, telephone, cash_balance, credit_limit = 0)
    @name = name
    @address = address
    @telephone = telephone
    @cash_balance = cash_balance
    @credit_limit = credit_limit
    @portfolios = {}
  end


  def to_s
    "#{name} of #{address}:\t#{portfolios.size} portfolios\t $#{cash_balance + credit_limit} available for purchases"
  end

  def to_s_long
   "#{name} of #{address}\nPortfolios: #{portfolios.size}\nCash balance: $#{cash_balance}\nCredit_limit: $#{credit_limit}\nAvailable for purchases: $#{cash_balance + credit_limit}"
  end




  def increase_balance(amount)
    cash balance += amount
    puts "Cash balance increased"
    to_s_long
  end


end