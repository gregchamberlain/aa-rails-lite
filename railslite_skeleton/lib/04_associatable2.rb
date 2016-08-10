require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method name do
      through_options = self.class.assoc_options[through_name] #human
      source_options = through_options.model_class.assoc_options[source_name] #HOUSE
      through_table = through_options.table_name
      source_table = source_options.table_name
      data = DBConnection.execute(<<-SQL, send(through_options.foreign_key))
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table} ON #{through_table}.#{source_options.foreign_key} =  #{source_table}.id
        WHERE
          #{through_table}.id = ?
      SQL
      source_options.model_class.new(data.first)
    end
  end
end
#
# SELECT
#   houses.*
# FROM
#   humans
# JOIN
#   houses ON humans.house_id = houses.id
# WHERE
#   human.id = self.owner_id
