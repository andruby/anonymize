require "anonymize/version"

module Anonymize
  autoload :GoogleNews, 'anonymize/google_news'
  autoload :SQL, 'anonymize/sql'
  class << self
    attr_accessor :definition, :connection, :options

    def define(connection, options = {}, &block)
      self.options = options
      self.connection = connection
      self.definition = {}
      class_eval &block
      Anonymize::SQL.run!(connection, options, self.definition)
    end

    def table(table_name, options = {}, &block)
      @table_name = table_name
      self.definition[@table_name] = {columns: {}, options: options}
      class_eval &block
    end

    def column(column_name, &block)
      self.definition[@table_name][:columns][column_name] = block
    end
  end
end
