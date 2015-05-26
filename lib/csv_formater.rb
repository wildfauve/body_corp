class CSVFormater
  
  def initialize(file: nil)
    @file = file
    @out = []
    self
  end
  
  def title(title)
    @title = title
  end
  
  def header(hdr)
    @out << hdr
  end
  
  def add_lines(line) 
    @out << line
  end
  
  def output
    CSV.open(@file, 'w') do |csv|
      @out.each do |row| 
        csv << row
      end
    end
  end
  
end