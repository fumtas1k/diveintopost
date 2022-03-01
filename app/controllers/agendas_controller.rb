class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    agenda = Agenda.find(params[:id])
    team = agenda.team
    if [agenda.user, team.owner].include?(current_user)
      agenda.destroy
      redirect_to dashboard_path, notice: "#{agenda.title}#{I18n.t('views.messages.delete_agenda_message')}"
      team.members.each do |member|
        TeamMailer.delete_agenda_mail(member, agenda.title, team).deliver_later
      end
    else
      redirect_back fallback_location: root_path, notice: I18n.t("views.messages.cannot_delete_agenda")
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
