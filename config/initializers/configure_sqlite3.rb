# Be sure to restart your server when you modify this file.

if ::ActiveRecord::Base.connection.is_a?(ActiveRecord::ConnectionAdapters::SQLite3Adapter)
  if (c = ::ActiveRecord::Base.connection)
    # Database configuration.
    # Pragmas that are only practical to customize at database-creation time (like `page_size`) should be avoided here.
    c.execute "PRAGMA main.journal_mode=WAL;"

    # Connection configuration
    c.execute "PRAGMA main.synchronous=NORMAL;"
  end
end
