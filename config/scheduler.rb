Rufus::Scheduler.singleton.tap do |s|
  s.every "1h" do
    Feed.stale.find_each(&:expire_if_stale!)
    Feed.unthrottleable.find_each(&:unthrottle!)
  end

  s.every "1d" do
    DatabaseBackup.run!
  end
end.join
