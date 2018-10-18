class UsersMailer < ApplicationMailer
  def invite_email(circle, email, user_name)
    @circle = circle
    @date = Time.now.getutc
    domain = 'http://localhost:4200'
    @path = domain +'/register/'+ @circle['id'].to_s + '/' + user_name
    mail(to: email, subject:"[Monito-Generator] You have been invited by #{@circle['owner']}!")
  end
end
