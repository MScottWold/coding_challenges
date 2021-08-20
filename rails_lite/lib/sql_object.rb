require_relative '../vendor/db_connection'
require 'active_support/inflector'
require_relative 'searchable'
require_relative 'associatable'

class SQLObject
  extend Searchable
  extend Associatable

  attr_accessor :errors

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym

      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end

      self.send("#{attr_name}=",value)
    end
  end

  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        1
    SQL
    .first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |name|
      self.define_method(name) { self.attributes[name] }

      self.define_method("#{name}=") { |value| self.attributes[name] = value }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result)}
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL

    return nil if result.empty?
    self.new(result[0])
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.attributes.values
  end

  def insert
    column_names = self.attributes.keys.join(", ")
    question_marks = (["?"] * self.attributes.length).join(", ")

    DBConnection.execute2(<<-SQL, self.attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{column_names})
      VALUES
        (#{question_marks})
    SQL

    last_record_id = DBConnection.last_insert_row_id
    attributes[:id] = last_record_id
  end

  def update
    set_line = ""

    self.class.columns.each do |column_name|
      next if column_name == :id
      set_line += column_name.to_s + " = " + ":#{column_name}, "
    end
    
    set_line = set_line[0...-2]

    DBConnection.execute(<<-SQL, self.attributes)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = :id
    SQL

    self
  end

  # Allows the use of (validate_presence_of :some_attr) in the model class
  class << self
    def validate_presence_of(*attrs)
      self.define_method(:save) do
        if attr_present?(attrs)
          if self.class.find(self.id).nil?
            self.insert
          else
            self.update
          end
          return true
        end
        false
      end
    end
  end

  private

  def attr_present?(attr_array)
    @errors ||= []
    attr_array.each do |attr|
      value = self.send(attr)
      if value.empty? || !value
        @errors << "#{attr} must be present"
      end
    end
    @errors.empty? ? true : false
  end
end