class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_USERNAME'] + '@' + ENV['EMAIL_DOMAIN']
  layout 'mailer'
end
