class Expenses
  
  attr_accessor :items
  
  def initialize
    @items = []
  end
  
  def config(&block)
    raise ArgumentError, "Needs a block" unless block_given?
    block.call(self) if block_given?
  end
  
  def set_cpi_to(value)
    @cpi = value
    self
  end
  
  
  def build_expenses(expenses: nil, type: nil)
    expenses.each {|item| @items << ExpenseItem.new(type: type, item: item)}
    self
  end
  
  def forecast_forward(end_date)
    date = payment_date(Date.today)
    start_year = date.year
    @forecast = []
    while date < end_date
      #@forecast << {date: date, amt: total_month_expenses}
      @forecast << {date: date, amt: total_month_expenses(apply_cpi: !@cpi.nil?, this_yr: date.year, start_yr: start_year)}      
      date = date.next_month
    end 
    @forecast
  end
  
  def payment_date(date)
    date.day > 15 ? Date.new(date.year, date.month + 1, 15) : Date.new(date.year, date.month, 15)
  end
  
  def total_month_expenses(apply_cpi: nil, this_yr: nil, start_yr: nil)
    amt = @items.select {|item| item.type == :fixed}.inject(0) {|sum, item| sum += monthly_fixed(item)}
    if apply_cpi && this_yr != start_yr
      amt = Util::Accumulate.new.amt_accum(amt: amt, curr_yr: start_yr, end_yr: this_yr, factor: @cpi)
    end
    amt
  end
  
  def monthly_fixed(item)
    item.monthly_amt
  end
  
  
  
end