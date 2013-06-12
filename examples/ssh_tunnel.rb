require_relative '../lib/anonymize.rb'

require 'mysql2'
require 'net/ssh/gateway'
require 'faker'

gateway = Net::SSH::Gateway.new('ssh_host', 'ssh_username')
port = gateway.open('127.0.0.1', 3306, 3307)

connection = Mysql2::Client.new(
  host: "127.0.0.1",
  database: 'db_name',
  username: 'db_user',
  password: 'db_password',
  port: port
)

Anonymize.define(connection, verbose: false, pretend: true, progress: true) do
  table :company do
    column(:summary) { |text| Anonymize::GoogleNews.related_news(text) if text.length > 3 }
    column(:name) { Faker::Company.name }
  end

  table :users do
    column(:name) { Faker::Name.name }
    column(:email) { Faker::Internet.email }
  end
end

connection.close