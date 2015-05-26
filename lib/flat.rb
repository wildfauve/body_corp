class Flat
  
  attr_accessor :fee, :number
  
  def initialize(number: nil, fee: nil)
    @number = number
    @fee = amt(fee)
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