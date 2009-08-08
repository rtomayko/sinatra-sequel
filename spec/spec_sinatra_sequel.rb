root = File.expand_path(File.dirname(__FILE__) + '/..') 
$: << "#{root}/lib"

require 'sinatra/base'
require 'sinatra/sequel'

class MockSinatraApp < Sinatra::Base
  register Sinatra::SequelExtension
end

describe 'A Sinatra app with Sequel extensions' do
  before {
    File.unlink 'test.db' rescue nil
    ENV.delete('DATABASE_URL')
    @app = Class.new(MockSinatraApp)
    @app.set :migrations_log, File.open('/dev/null', 'wb')
  }

  it 'exposes the Sequel database object' do
    @app.should.respond_to :database
  end

  it 'uses the DATABASE_URL environment variable if set' do
    ENV['DATABASE_URL'] = 'sqlite://test-database-url.db'
    @app.database_url.should.equal 'sqlite://test-database-url.db'
  end

  it 'uses sqlite://<environment>.db when no DATABASE_URL is defined' do
    @app.environment = :foo
    @app.database_url.should.equal "sqlite://foo.db"
  end

  it 'establishes a database connection when set' do
    @app.database = 'sqlite://test.db'
    @app.database.should.respond_to :table_exists?
  end

  it 'runs database migrations' do
    @app.database = 'sqlite://test.db'
    @app.migration 'create the foos table' do |db|
      db.create_table :foos do
        primary_key :id
        text :foo
        integer :bar
      end
    end

    @app.database[:migrations].count.should.equal 1
    @app.database.should.table_exists :foos
  end

  it 'does not run database migrations more than once' do
    @app.database = 'sqlite://test.db'
    @app.migration('this should run once') { }
    @app.migration('this should run once') { fail }
    @app.database[:migrations].count.should.equal 1
  end
end
