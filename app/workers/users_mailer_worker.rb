class UsersMailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(circle, email, user_name)
    UsersMailer.invite_email(circle, email, user_name).deliver_now
  end
end
