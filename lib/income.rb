class Income
  
  def initialize
    @flats = []
  end
  
  def config(&block)
    raise ArgumentError, "Needs a block" unless block_given?
    block.call(self) if block_given?
  end
  
  
  def set_cpi_to(value)
    @cpi = value
    self
  end
  
  def build_fees(fees)
    fees.each {|fee| @flats << Flat.new(number: fee[:number], fee: fee[:fee])}
    self
  end
  
  def forecast_forward(end_date)
    date = payment_date(Date.today)
    start_year = date.year
    @forecast = []
    while date < end_date
      @forecast << PLEntry.new(date: date, amt: total_month_fees(apply_cpi: !@cpi.nil?, this_yr: date.year, start_yr: start_year))
      date = date.next_month
    end
    @forecast 
  end
  
  
  def payment_date(date)
    date.day > 15 ? Date.new(date.year, date.month + 1, 15) : Date.new(date.year, date.month, 15)
  end
  
  def total_month_fees(apply_cpi: nil, this_yr: nil, start_yr: nil)
    amt = @flats.inject(0) {|sum, flat| sum += flat.fee} 
    if apply_cpi && this_yr != start_yr
      amt = Util::Accumulate.new.amt_accum(amt: amt, curr_yr: start_yr, end_yr: this_yr, factor: @cpi)
    end
    amt
  end
    
  
end