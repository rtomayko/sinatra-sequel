require 'time'
require 'sinatra/base'
require 'sequel'

module Sinatra
  module SequelHelper
    def database
      options.database
    end
  end

  module SequelExtension
    def database=(url)
      @database = nil
      set :database_url, url
      database
    end

    def database
      @database ||=
        Sequel.connect(database_url)
    end

    def sqlite?
      defined?(Sequel::SQLite::Database) && database.kind_of?(Sequel::SQLite::Database)
    end

    # TODO: wrong!
    def postgres?
      ! sqlite?
    end

    def migration(name, &block)
      create_migrations_table
      return if database[:migrations].filter(:name => name).count > 0
      migrations_log.puts "Running migration: #{name}"
      database.transaction do
        yield database
        database[migrations_table_name] << { :name => name, :ran_at => Time.now }
      end
    end

  protected

    def create_migrations_table
      database.create_table? :migrations do
        primary_key :id
        text :name, :null => false, :index => true
        timestamp :ran_at
      end
    end

    def self.registered(app)
      app.set :database_url, lambda { ENV['DATABASE_URL'] || "sqlite://#{environment}.db" }
      app.set :migrations_table_name, :migrations
      app.set :migrations_log, lambda { STDOUT }
      app.helpers SequelHelper
    end
  end

  register SequelExtension
end
