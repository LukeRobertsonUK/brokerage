class Portfolio
  attr_accessor :name, :type, :holdings

  def initialize(name, type)
    @name = name
    @type = type
    @holdings = {}
  end

  def to_s
    "#{name}: #{type} fund with #{holdings.size} holdings"
  end







end