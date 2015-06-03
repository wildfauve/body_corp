class BalanceSheet

  def initialize(income: nil, expenses: nil)
  end
  
  def scenario(title, &block)
    @title = title
    raise ArgumentError, "Needs a block" unless block_given?
    block.call(self) if block_given?
  end
  
  def set_pl(income: nil, expenses: nil)
    @profit = income
    @expenses = expenses
  end    
  
  def set_cpi(cpi)
    @cpi = cpi
  end
  
  def forecast_period=(date)
    @end_date = date
  end
  
  def output_to(formater: nil, file: nil)
    @formater = formater
    @output_file = file
  end

  def run
    @profit = @profit.set_cpi_to(@cpi).forecast_forward(@end_date)  
    @loss = @expenses.set_cpi_to(@cpi).forecast_forward(@end_date)
    output()
  end
  
  def month_seq
    @mths ||= (@loss.collect {|line| line.date}.concat @profit.collect {|line| line.date }).uniq    
  end
    
  # TODO: use a formatter pattern
  def output(file: nil)
    @form = @formater.new(file: @output_file)
    @form.title(@title)
    @form.header(month_seq.collect {|m| m.to_s})
    @form.add_lines(gen_line(title: "Fees Income", input: @profit))
    @form.add_lines(gen_line(title: "Fixed Expenses", input: @loss))
    @form.output
  end

  def gen_line(title: nil, input: nil)
    line = [title]
    month_seq.each do |mth|
      amt_date = input.find {|l| l.date == mth}
      amt_date.nil? ? line << "" : line << amt_date.amt.format
    end
    line
  end
    
end
