class Holding
  attr_accessor :ticker, :num_shares, :share_name, :share_price

  def initialize(ticker, num_shares)
    @ticker = ticker
    @num_shares = num_shares
    @share_name = YahooFinance::get_standard_quotes(@ticker.to_s)[@ticker.to_s].name
    @share_price = YahooFinance::get_standard_quotes(@ticker.to_s)[@ticker.to_s].lastTrade

  end

  def to_s
    "#{ticker}: #{num_shares} shares in #{share_name} valued at $#{(num_shares*share_price).round(2)}"
  end







end