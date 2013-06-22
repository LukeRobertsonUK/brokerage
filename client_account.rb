class ClientAccount
  attr_accessor :name, :address, :telephone, :cash_balance, :credit_limit, :portfolios

  def initialize(name, address, telephone, cash_balance, credit_limit)
    @name = name
    @address = address
    @telephone = telephone
    @cash_balance = cash_balance
    @credit_limit = credit_limit
    @portfolios = {}
  end

  def to_s
   "#{name} of #{address}\nPortfolios: #{portfolios.size}\nCash balance: $#{cash_balance}\nCredit_limit: $#{credit_limit}\nAvailable for share purchases: $#{cash_balance + credit_limit}"
  end


end