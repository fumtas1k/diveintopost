class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy transfer_owner]
  before_action :team_owner_required, only: %i[edit update destroy transfer_owner]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def transfer_owner
    assign_user = Assign.find(params[:assign_id]).user
    if @team.update(owner_id: assign_user.id)
      redirect_to @team, notice: "#{assign_user.email}に#{I18n.t('views.messages.transfer_team_owner')}"
    else
      redirect_back fallback_location: @team, notice: I18n.t('views.messages.failed_to_transfer_team_owner')
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end

  def team_owner_required
    team = Team.friendly.find(params[:id])
    unless current_user == team.owner
      flash[:notice] =
        if action_name == "transfer_owner"
          I18n.t('views.messages.cannot_transfer_team_owner')
        else
          I18n.t('views.messages.cannot_update_team')
        end
      redirect_back fallback_location: team
    end
  end
end
