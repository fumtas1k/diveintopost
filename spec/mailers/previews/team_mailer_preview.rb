# Preview all emails at http://localhost:3000/rails/mailers/team_mailer
class TeamMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/team_mailer/transfer_owner_mail
  def transfer_owner_mail
    TeamMailer.transfer_owner_mail
  end

end
