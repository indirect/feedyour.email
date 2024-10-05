class DatabaseBackup
  def self.run!
    new.run
  end

  def run
    FileUtils.rm_rf backup_path
    conn.execute "VACUUM INTO #{conn.quote(backup_path.to_s)}"
    backup_path
  end

  private

  def conn
    ActiveRecord::Base.connection
  end

  def backup_path
    Rails.root.join("storage", Rails.env, "backup.sqlite3") # rubocop:disable Lint/Env
  end
end
