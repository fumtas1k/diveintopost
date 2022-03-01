class TeamMailer < ApplicationMailer

  def transfer_owner_mail(old_owner, new_owner, team)
    @old_owner = old_owner
    @new_owner = new_owner
    @team = team
    mail to: @new_owner.email, subject: I18n.t('views.messages.complete_transfer')
  end

  def delete_agenda_mail(member, agenda_title, team)
    @member = member
    @agenda_title = agenda_title
    @team = team
    mail to: @member.email, subject: I18n.t('views.messages.delete_agenda')
  end

end
