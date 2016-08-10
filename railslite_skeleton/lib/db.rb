require_relative 'db_connection'

class DBTypes

  def initialize
    @columns = []
  end

  [
    {name: "integer", type: "INT(11)"},
    {name: "decimal", type: "DECIMAL(8,2)"},
    {name: "text", type: "TEXT"},
    {name: "string", type: "VARCHAR"},
    {name: "timestamp", type: "TIMESTAMP"},
    {name: "date", type: "DATE"},
  ].each do |col|
    define_method col[:name] do |name, options = {}|
      @columns << {name: name, type: col[:type], options: options}
    end
  end

  def columns
    @columns
  end

end


def create_table(name, &prc)
  cols = DBTypes.new
  prc.call(cols)
  {name: name, cols: cols.columns}
end
