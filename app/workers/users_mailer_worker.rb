class UsersMailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(circle, email)
    UsersMailer.invite_email(circle, email).deliver_now
  end
end
