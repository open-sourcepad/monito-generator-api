module Users
  class EmailPairer
    def self.pair_users(circle, users_codenames, users_circles, users_emails)
      len = users_emails.length
      for x in 0...len-1
        monito_codename = users_codenames[x+1]
        NotifyMailerWorker.perform_async(circle, users_emails[x], users_circles[x+1]['wishlist'], monito_codename)
      end
      NotifyMailerWorker.perform_async(circle, users_emails[len-1], users_circles[0]['wishlist'], users_codenames[0])
    end 
  end
end
