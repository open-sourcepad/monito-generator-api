class NotifyMailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(circle, email, monito_codename, wishlist)
    UsersMailer.gen_inform_email(circle, email, monito_codename, wishlist).deliver_now
  end
end
