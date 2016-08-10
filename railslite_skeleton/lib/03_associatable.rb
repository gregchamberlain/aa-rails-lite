require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.to_s.singularize.camelize.constantize
  end

  def table_name
    name = @name.tableize
    name == "humen" ? "humans" : name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name.to_s
    @class_name = options[:class_name] || name.to_s.camelcase
    @foreign_key = options[:foreign_key] ? options[:foreign_key] :  "#{name}_id".to_sym
    @primary_key = options[:primary_key] ? options[:primary_key] : :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name.to_s
    @class_name = options[:class_name] || @name.singularize.camelcase
    @foreign_key = options[:foreign_key] || "#{self_class_name.underscore}_id".to_sym
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, opts = {})
    options = BelongsToOptions.new(name, opts)
    assoc_options[name] = options
    define_method name do
      options.model_class.where({options.primary_key => send(options.foreign_key)}).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method name do
      options.model_class.where({options.foreign_key => send(options.primary_key)})
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
