#require_relative 'lib/*.*'
Dir["#{Dir.pwd}/lib/*.rb"].each {|file| require file }

require 'rubygems'
require 'bundler/setup'
require 'date'
require 'csv'
Bundler.require

I18n.enforce_available_locales = false

fees = [
  {number: "1/23b", fee: "$400.00"},
  {number: "2/23b", fee: "$300.00"},
]

fixed_costs = [

  {title: "Rubbish", amt: "$1447.38", period: :annual},
  {title: "Power", amt: "$3324.29", period: :annual}, 
  {title: "Insurance", amt: "$15749.98", period: :annual}, 
  {title: "Service Fee (bank)", amt: "$132.00", period: :annual}, 
  {title: "Monthly Fee (bank)", amt: "$124.08", period: :annual}, 
  {title: "Gardener", amt: "$1320.00", period: :annual}, 
  {title: "Drainage Control", amt: "$316.25", period: :annual}, 
  {title: "Miscellaneous R & M",amt: "$191.38", period: :annual}, 
  {title: "Professional Fees & memberships", amt: "$6600.00", period: :annual} 

  
]

ltmp = [

  {code: "2.2", title: "Repave driveway/Carpark area", amt: "$80000.00"},
  {code: "2.19", title: "(new item): replace sewerage line from 23B to Evans Bay Parade", amt: "$7000.00"},
  {code: "2.20", title: "(new item) - 23C switchboard (subject to legal advice on liability for this work)", amt: "$22950.00"},
  {code: "3.3", title: "Improve hard landscaping", amt: "$12820.00"},
  {code: "3.4", title: "Courtyard paving outside 3&4 23B", amt: "$14040.00"},
  {code: "2.6", title: "Repair plaster work to free standing garages and repaint", amt: "$14000.00"},
  {code: "2.9", title: "Re-roof 23C (see notes on next page)", amt: "$10"},
  {code: "2.5", title: "23C Foyer repaint and recarpet", amt: "$10"},
  {code: "3.2", title: "Repave footpath to 23A&B (see notes on next page)", amt: "$10"},
  {code: "3.7", title: "New garage doors to 23C building (see notes on next page)", amt: "$10"},
  
]


@income = Income.new.config do |inc|
  inc.build_fees fees
end

@expenses = Expenses.new.config do |exp|
  exp.build_expenses(type: :fixed, expenses: fixed_costs)
end

BalanceSheet.new.scenario("Base Scenario") do |pl|
  pl.set_cpi 0.02
  pl.set_pl(income: @income, expenses: @expenses)
  pl.forecast_period = Date.today.next_year.next_year
  pl.output_to(formater: CSVFormater, file: "base_scenario.csv")
  pl.run
end

