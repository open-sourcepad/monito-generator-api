class UsersMailer < ApplicationMailer
  def invite_email(circle, email, user_name)
    @circle = circle
    @date = Time.now.getutc
    domain = 'http://localhost:4200'
    @path = domain +'/register/'+ @circle['hash_id'].to_s + '/' + user_name
    mail(to: email, subject:"[Monito-Generator] You have been invited by #{@circle['owner']}!")
  end
  def gen_inform_email(circle, email, wishlist, monito_codename)
    @circle = circle
    @user_events = UserEvent.where(circle_id: @circle['id']).order("exchange_date ASC")
    @events_title = if (@user_events.length > 1) then "Mini Exchanges:" else "" end
    @monito_codename = monito_codename
    @date = Time.now.getutc
    @wishlist = JSON.parse wishlist

    mail(to: email, subject:"[Monito-Generator] Your pairing is ready in #{@circle['circle_name']}!")
  end
end
