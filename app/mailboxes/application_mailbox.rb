class ApplicationMailbox < ActionMailbox::Base
  routing(%r{.*} => :post)
end
