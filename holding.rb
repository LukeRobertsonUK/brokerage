class Holding
  attr_accessor :ticker, :num_shares, :share_name, :share_price

  def initialize(ticker, num_shares)
    @ticker = ticker
    @num_shares = num_shares
    @share_name = YahooFinance::get_standard_quotes(@ticker.to_s)[@ticker.to_s].name
    @share_price = YahooFinance::get_standard_quotes(@ticker.to_s)[@ticker.to_s].lastTrade

  end




  def holding_value
    value = @num_shares * YahooFinance::get_standard_quotes(@ticker.to_s)[@ticker.to_s].lastTrade
  end


 def to_s
    "#{ticker}: #{num_shares} shares in #{share_name} valued at $#{holding_value.round(2)}"
  end



end