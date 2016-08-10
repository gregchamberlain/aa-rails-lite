require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |k| "#{k} = ?" }.join(" AND ")
    vals = params.values
    data = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL
    data.map { |datum| self.new(datum) }
  end
end

class SQLObject
  extend Searchable
end
