# Be sure to restart your server when you modify this file.

if ::ActiveRecord::Base.connection.is_a?(ActiveRecord::ConnectionAdapters::SQLite3Adapter)
  if (c = ::ActiveRecord::Base.connection)
    # Database configuration.
    c.execute "PRAGMA main.journal_mode=WAL;"

    # Connection configuration
    c.execute "PRAGMA main.synchronous=NORMAL;"
  end
end
