class SkillsController < ApplicationController
    def show
      skill = Skill.new
      # 対象ユーザー
      @user = User.find params[:id]
      # 対象ユーザーが所有しているスキル一覧を取得。
      user_has_skills = skill.get_skills_of_target_user params[:id], current_user.id
      # 推薦数が多い順に対象ユーザーが保持しているスキルを取得
      @user_recommend_count_each_skills = skill.get_user_recommend_count params[:id], user_has_skills
      # 対象ユーザーのスキルを推薦されているレコードを取得し、スキルIDごとにグループ分けを行う。各スキルIDのvalの要素数の値が推薦数となる。
      @skill_recommend_count = skill.get_skill_recommend_count params[:id], user_has_skills

      @skill_master = SkillMaster.all
      @create_skills = SkillMaster.new
      @skill = Skill.new(:user_id => params[:id])
      # 他のユーザーに追加されたスキルを取得
      @other_user_add_skills = skill.get_skill_id_other_user_add_skill_to_me params[:id]

      # スキルIDをkeyとして、valに対象スキルを保有しているユーザーを格納
      @recommend_skill_users = SkillRecommend.where(owner_user_id: params[:id], recommend_flg: 1).where.not(skill_master_id: nil).group_by {|g| g.skill_master_id}

      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @user = User.find params[:user_id]
      # スキルの推奨数を格納
      @skill_recommend_count = {}

      # 対象ユーザーに追加するスキルIDを格納
      new_skill_ids = []
      # 対象ユーザーにスキルを追加
      params[:skill][:id].each do |skill|
        @add_skill = Skill.new(
          user_id: params[:user_id],
          create_skill_user_id: current_user.id,
          display_flg: 0,
          skill_master_id: skill.to_i
        )
        @add_skill.save
        new_skill_ids.push(skill)
      end
      # 追加するスキルをスキルIDでグループ分け
      @new_skills = SkillMaster.where(id: new_skill_ids).group_by{|g| g.id}
      # 他のユーザーに追加されたスキルを取得
      @other_user_add_skills = Skill.new.get_skill_id_other_user_add_skill_to_me params[:user_id]

      respond_to do |format|
        format.html 
        format.js {render :show}
      end
      
    end

    def ajax_update
      # 誰が所有しているどのスキルに対して誰が推薦を行ったかが分かるレコードを取得。誰からも推薦されていなければ、nilが帰ってくる。
      update_skill_recommend = SkillRecommend.where(skill_master_id: params[:skill_id], user_id: current_user.id, owner_user_id: params[:owner_user]).first
      
      # 誰かがスキルの推奨を１度でも行われていた場合。推奨したがキャンセルした場合も含まれる。
      unless update_skill_recommend.blank?
        # スキルが推奨されている時、スキルの推奨を取り消す。（あるユーザーが＋１を行っている時、＋１をキャンセルする時）
        if update_skill_recommend.recommend_flg == 1
          update_skill_recommend.update_attribute(:recommend_flg, 0)
        # スキルが推奨されていない時、スキルの推奨をする。（あるユーザーが＋１をキャンセルしている時、スキルに＋１を行う）
        else
          update_skill_recommend.update_attribute(:recommend_flg, 1)
        end
      # 誰からも推薦されていない時、新規でレコードを作成
      else
        SkillRecommend.new(
          # スキルの所有者
          owner_user_id: params[:owner_user],
          # スキルの推薦者
          user_id: current_user.id,
          # スキルID
          skill_master_id: params[:skill_id],
          # 推薦されているかを判定するflg。１の時⇛推奨されている状態、０の時⇛推奨されていない状態
          recommend_flg: 1
        ).save
      end
      # 対象ユーザーの対象のスキルに対しての推薦数を取得
      @skill_recommend_count = SkillRecommend.where(skill_master_id: params[:skill_id], owner_user_id: params[:owner_user], recommend_flg: 1).length

      @owner_user = params[:owner_user]
      @skill_id = params[:skill_id]

      respond_to do |format|
        format.js
      end
    end

    def ajax_display
      @update_skill_display = Skill.where(skill_master_id: params[:skill_id], user_id: params[:user_id]).first
      # 非表示のとき
      if @update_skill_display.display_flg == 1
        @update_skill_display.update_attribute(:display_flg, 0)
      # 表示の時
      else
        @update_skill_display.update_attribute(:display_flg, 1)
      end
      @user_id = params[:user_id]
      @skill_id = params[:skill_id]

      respond_to do |format|
        format.js
      end
    end

end
