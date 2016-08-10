require_relative '01_sql_object'
require_relative '03_associatable'
require_relative '02_searchable'
class ModelBase < SQLObject
  extend Associatable
  extend Searchable
end
