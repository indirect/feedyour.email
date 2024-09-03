Rufus::Scheduler.singleton.tap do |s|
  s.every "1h" do
    Feed.stale.find_each(&:expire_if_stale!)
  end
end.join
