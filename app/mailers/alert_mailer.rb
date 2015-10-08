class AlertMailer < ActionMailer::Base
  default from: "rampal0806@gmail.com"

  def alert_email(email)
    mail(to: email, subject: 'Book availability alert')
  end
end
