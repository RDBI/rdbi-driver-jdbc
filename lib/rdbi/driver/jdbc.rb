require 'rdbi'
require 'rubygems'

class RDBI::Driver::JDBC < RDBI::Driver
  def initialize(*args)
    super Database, *args
  end
end

class RDBI::Driver::JDBC < RDBI::Driver

  class Database < RDBI::Database
    
    attr_accessor :handle

    def initialize(*args)
      super *args

      database = @connect_args[:database] || @connect_args[:dbname] ||
        @connect_args[:db]
      username = @connect_args[:username] || @connect_args[:user]
      password = @connect_args[:password] || @connect_args[:pass]

      @handle = java.sql.DriverManager.getConnection(
                  "jdbc:#{database}"
                  username,
                  password
                )

      self.database_name = @handle.get_info("SQL_DATABASE_NAME")
    end

    def disconnect
      @handle.rollback
      @handle.disconnect
      super
    end

    def transaction(&block)
      raise RDBI::TransactionError, "Already in transaction" if in_transaction?
      @handle.transaction{super}
    end

    def rollback
      @handle.rollback
      super
    end

    def commit
      @handle.commit
      super
    end

    def new_statement(query)
      Statement.new(query, self)
    end

    def table_schema(table_name)
      new_statement(
        "SELECT * FROM #{table_name} WHERE 1=2"
      ).new_execution[1]
    end

    def schema
      sth = @handle.getMetaData.getTables(nil, nil, nil, nil)
      tables = []
      while r = sth.next
        tables << table_schema(r.getString(3))
      end
      tables
    end

    def ping
      !@handle.isClosed
    end

    def quote(item)
      case item
      when Numeric
        item.to_s
      when TrueClass
        "1"
      when FalseClass
        "0"
      when NilClass
        "NULL"
      else
        "'#{item.to_s}'"
      end
    end

  end

  class Database < RDBI::Cursor
  end

  class Statement < RDBI::Statement
end
