class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    Rails.logger.info "Got an email!\n\n#{@email.to_h.inspect}"
  end
end
