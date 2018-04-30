class UsersController < ApplicationController
    def show
      same_skill_user_group = Skill.where(skill_master_id: params[:id]).pluck('DISTINCT user_id')
      @same_skill_users = User.where(id: same_skill_user_group).where.not(id: current_user.id)
      @skill = SkillMaster.find(params[:id])

      respond_to do |format|
        format.html
      end
    end

    def create
      @user = User.new(
        name: params[:name],
        password_digest: params[:password_digest]
        )
      @user.save

      respond_to do |format|
        format.html {render 'logins/index'}
      end
    end
  
end