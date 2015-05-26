class Util
  
  class Accumulate
    
    def amt_accum(amt: nil, curr_yr: nil, end_yr: nil, factor: nil)
      if curr_yr < end_yr
        amt_accum(amt: amt += amt * factor, curr_yr: curr_yr + 1, end_yr: end_yr, factor: factor)
      else
        amt
      end
    end
    
  end
end