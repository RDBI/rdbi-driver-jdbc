require 'rdbi'
require 'rubygems'

class RDBI::Driver::JDBC < RDBI::Driver
  def initialize(*args)
    super Database, *args
  end
end

class RDBI::Driver::JDBC < RDBI::Driver

  class Database < RDBI::Database
  end

  class Database < RDBI::Cursor
  end

  class Statement < RDBI::Statement
end
