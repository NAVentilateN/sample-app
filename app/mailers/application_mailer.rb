class ApplicationMailer < ActionMailer::Base
  
  if Rails.env.production?
    email = "NoEmailAccount@email.com"
  else
    email = "from@example.com"
  end
  default from: email
  layout "mailer"
end
