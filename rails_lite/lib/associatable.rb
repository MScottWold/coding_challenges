require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = "#{name}_id".to_sym
    @class_name = name.to_s.camelcase
    @primary_key = :id

    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @self_class_name = self_class_name.constantize
    @foreign_key = "#{@self_class_name.to_s.underscore}_id".to_sym
    @class_name = name.to_s.singularize.camelcase
    @primary_key = :id
    
    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    self.define_method(name) do
      options = self.class.assoc_options[name]
      id_val = self.send(options.foreign_key)
      options.model_class.where(id: id_val).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)
    
    self.define_method(name) do
      options = self.class.assoc_options[name] 
      foreign_key_val = self.send(options.primary_key)

      options.model_class.where(options.foreign_key => foreign_key_val)
    end
  end

  def has_one_through(name, through_name, source_name)
    self.define_method(name) do 
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      
      self_foreign_key_value = self.send(through_options.foreign_key) 
      
      source_table = source_options.table_name
      through_table = through_options.table_name
      join_condition = "#{source_table}.#{source_options.primary_key} = #{through_table}.#{source_options.foreign_key}"

      result = DBConnection.execute(<<-SQL, self_foreign_key_value)
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table} ON #{join_condition}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
      SQL

      source_options.model_class.new(result[0])
    end

  end  

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end