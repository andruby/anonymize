require_relative '../lib/anonymize.rb'

require 'mysql2'
require 'net/ssh/gateway'
require 'faker'

# Set up an ssh gateway
gateway = Net::SSH::Gateway.new('ssh_host', 'ssh_username')
port = gateway.open('127.0.0.1', 3306, 3307)

# Connect through the local ssh gateway to the real server
connection = Mysql2::Client.new(
  host: "127.0.0.1",
  database: 'db_name',
  username: 'db_user',
  password: 'db_password',
  port: port
)

Anonymize.define(connection, verbose: false, pretend: true, progress: true) do
  table :company do
    # If the Proc returns false or nil, the value is not updated.
    column(:summary) { |text| Anonymize::GoogleNews.related_news(text) if text.length > 3 }
    column(:name) { Faker::Company.name }
  end

  # Using up to 5 retries to prevent uniqueness errors
  table :users, retries: 5 do
    # Use a Proc with 2 arguments to the full row for simple conditionals
    column(:name) { |name, row| Faker::Name.name unless row["super_user"] == 1 }
    column(:email) { Faker::Internet.email }
  end
end

connection.close