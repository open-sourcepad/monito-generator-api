module Users
  class EmailPairer
    def self.pair_users(circle, users_codenames, users_emails)
      len = users_emails.length
      for x in 0..len-1
        monito_codename = users_codenames[x+1]
        NotifyMailerWorker.perform_async(circle, users_emails[x], monito_codename, nil)
      end
      NotifyMailerWorker.perform_async(circle, users_emails[len-1], users_codenames[0], nil)
    end 
  end
end
