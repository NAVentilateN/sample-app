class ApplicationMailer < ActionMailer::Base
  
  if Rails.env.production?
    email = "valentinetan91@gmail.com"
  else
    email = "from@example.com"
  end
  default from: email
  layout "mailer"
end
