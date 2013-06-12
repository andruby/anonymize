autoload :ProgressBar, "ruby-progressbar"

class Anonymize::SQL
  def initialize(connection, options, definition)
    @connection = connection
    @options = options
    @definition = definition
  end

  def self.run!(*args)
    self.new(*args).run!
  end

  def run!
    total_count = @definition.count
    counter = 0
    @definition.each do |table, data|
      puts "(#{counter+=1}/#{total_count}) Anonymizing columns #{data[:columns].keys.inspect} from table '#{table}'"
      process_table(table, data)
    end
  end

  def process_table(table, data)
    columns = data[:columns]
    rows = @connection.query("SELECT id, #{columns.keys.join(', ')} FROM #{table}")
    pbar = ProgressBar.create(:format => '%a %B %c of %C', :total => rows.count) if @options[:progress]
    rows.each do |row|
      tuples = {}
      columns.each do |column, proc|
        replacement = replacement(column, row, proc)
        tuples[column] = replacement if replacement
      end
      update_row(row["id"], table, tuples)
      pbar.increment if @options[:progress]
    end
  end

  def replacement(column, row, proc)
    original = row[column.to_s]
    case proc.arity
    when 1 then proc.call(original)
    when 2 then proc.call(original, row)
    else proc.call
    end
  end

  def update_row(id, table, tuples)
    if tuples.count > 0
      update_part = tuples.map { |column, value| "#{column} = \"#{@connection.escape(value)}\"" }
      update_sql = "UPDATE #{table} SET #{update_part.join(', ')} WHERE id = #{id}"
      puts update_sql if @options[:verbose]
      @connection.query(update_sql) unless @options[:pretend]
    end
  end
end