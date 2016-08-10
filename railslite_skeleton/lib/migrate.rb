require_relative "db"
require_relative 'db_connection'
file = __FILE__
index = file.index("lib/migrate.rb")
path = file[0...index] + "db/migrate/*"
files = Dir[path]
files.each do |file|
  obj = eval(File.read(file))
  name = obj[:name].upcase
  cols = ""
  obj[:cols].each do |col|
    cols += "#{col[:name]} #{col[:type]},"
  end
  cols = cols[0...-1]
  DBConnection.execute2(<<-SQL)
    CREATE TABLE #{name} (
      ID INTEGER PRIMARY KEY,#{cols}
    )
  SQL
end
