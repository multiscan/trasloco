# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAIL_ADDRESS"] || 'noreply@example.com'
  layout 'mailer'
end
