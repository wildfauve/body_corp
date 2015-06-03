class PLEntry
  
  attr_accessor :amt, :date
  
  def initialize(date: nil, amt: nil)
    @date = date
    @amt = amt
  end
  
end