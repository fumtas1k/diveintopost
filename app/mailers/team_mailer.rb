class TeamMailer < ApplicationMailer

  def transfer_owner_mail(old_owner, new_owner, team)
    @old_owner = old_owner
    @new_owner = new_owner
    @team = team
    mail to: @new_owner.email, subject: I18n.t('views.messages.complete_transfer')
  end

end
