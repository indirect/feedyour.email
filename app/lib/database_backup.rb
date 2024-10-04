class DatabaseBackup
  def self.run!
    new.run
  end

  def run
    `sqlite3 #{Shellwords.escape db_path} "VACUUM INTO '#{Shellwords.escape backup_path}'"`
    `gzip -f9 #{Shellwords.escape backup_path}`

    "#{backup_path}.gzip"
  end

  private

  def db_path
    Rails.root.join "storage", Rails.env, "data.sqlite3" # rubocop:disable Lint/Env
  end

  def backup_path
    Rails.root.join "storage", Rails.env, "backup.sqlite3" # rubocop:disable Lint/Env
  end
end
