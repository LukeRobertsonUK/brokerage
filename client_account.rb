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
    "#{name} of #{address}:\t#{portfolios.size} portfolios valued at $#{account_value}\t  $#{(cash_balance + credit_limit).to_f.round(2)} available for purchases"
  end

  def to_s_long
     puts "\n---------------------------------------------------------------------"
     puts "ACCOUNT SUMMARY"
     puts "#{name} of #{address}\nPortfolios: #{portfolios.size}\nCombined portfolio value: $#{account_value}\nCash balance: $#{cash_balance}\nCredit_limit: $#{credit_limit}\nAvailable for purchases: $#{cash_balance + credit_limit}"
    puts "---------------------------------------------------------------------"
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

  def account_value
    value = 0
    portfolios.each do |portfolio|
     value += portfolio.portfolio_value
    end
    value.round(2)
  end

  def display_holdings_by_portfolio
    portfolios.each do |portfolio|
      puts "\n---------------------------------------------------------------------"
      puts portfolio.to_s
      puts "---------------------------------------------------------------------"
      portfolio.display_holdings
    end
  end


end