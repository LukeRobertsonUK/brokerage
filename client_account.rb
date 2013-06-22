class ClientAccount
  attr_accessor :name, :address, :telephone, :cash_balance, :credit_limit, :portfolios, :available_funds

  def initialize(name, address, telephone, cash_balance, credit_limit = 0)
    @name = name
    @address = address
    @telephone = telephone
    @cash_balance = cash_balance
    @credit_limit = credit_limit
    @portfolios = []
    @available_funds = @cash_balance + @credit_limit
  end


  def to_s
    "#{name} of #{address}:\t#{portfolios.size} portfolios\t $#{cash_balance + credit_limit} available for purchases"
  end

  def to_s_long
   "#{name} of #{address}\nPortfolios: #{portfolios.size}\nCash balance: $#{cash_balance}\nCredit_limit: $#{credit_limit}\nAvailable for purchases: $#{cash_balance + credit_limit}"
  end

  def increase_balance(amount)
    @cash_balance += amount
    puts "Cash balance increased..."
    puts self.to_s_long
  end

  def increase_credit(amount)
    @credit_limit += amount
    puts "Credit limit increased..."
    puts self.to_s_long
  end

  def list_portfolios
    portfolios.each_index do |index|
      puts "#{index +1}) #{portfolios[index].to_s}"
    end
  end


end