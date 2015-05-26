class ExpenseItem
  
  attr_accessor :type, :amt
  
  def initialize(item: nil, type: nil)
    @type = type
    @amt = amt(item[:amt])
    @title = item[:title]
    @code = item[:code]
    @period = item[:period]
    self
  end
  
  def annual?
    @period == :annual ? true : false
  end
  
  def monthly_amt
    self.annual? ? @amt / 12 : raise
  end

  def amt(amt)
    raise "Rate (#{amt})does not appear to be a number" unless /^[\d]+(\.[\d]+){0,1}$/ === amt.gsub(/\$/, "")
    money_amt = Monetize.parse(amt, "NZD")
    if [Fixnum, Money].include? money_amt.class
      money_amt if money_amt.is_a? Money
    else
      raise "Rate is not a Money value"
    end
  end

  
end