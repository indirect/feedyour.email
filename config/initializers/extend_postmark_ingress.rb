require "action_mailbox/base_controller"
require "throttle_by_feed"
ActionMailbox::BaseController.include ThrottleByFeed
