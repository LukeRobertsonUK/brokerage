class Portfolio
  attr_accessor :name, :type, :holdings

  def initialize(name, type)
    @name = name
    @type = type
    @holdings = {}
  end

  def to_s
    "#{name}: #{type} fund with #{holdings.size} holdings, valued at $#{portfolio_value}"
  end

  def portfolio_value
    value = 0
    holdings.each_value do |holding|
      value += holding.holding_value
    end
    value.round(2)
  end

  def display_holdings
    holdings.each_value do |holding|
      puts holding.to_s
    end
  end


end