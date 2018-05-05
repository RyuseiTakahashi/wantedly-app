class SkillMastersController < ApplicationController
  # マスタに対してスキルを登録
  def create
    @add_skill_master = SkillMaster.new(name: params[:skill_master][:name])
    @add_skill_master.save
    if @add_skill_master.save
      @skill_master_all = SkillMaster.all
      @skill_master = Skill.new(:user_id => params[:user_id])
      respond_to do |format|
        format.html {render 'skills/show'}
        format.js {render 'skills/show'}
      end
    else
      flash.now.alert = "もう一度入力してください。"
      render "new"
    end
  end

  def destroy
    skill_master = SkillMaster.find(params[:id]).destroy
  end

end
