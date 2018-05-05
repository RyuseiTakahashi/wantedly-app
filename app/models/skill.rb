class Skill < ApplicationRecord
    belongs_to :skill_master
    belongs_to :user

    # 自分が保持しているスキルを取得
    def get_skills_of_target_user user_id, login_user_id
        # ログインユーザーとスキル追加対象のユーザーが等しいときは表示flgに関係なく全て表示
        if user_id.to_i == login_user_id.to_i
            return SkillMaster.left_outer_joins(:skills).where(skills: {user_id: user_id}).group_by {|g| g.id}
        # ログインユーザーとスキル追加対象のユーザーが異なるときに、他ユーザーに追加されたスキルの表示flgの更新が行えるため、他ユーザーに追加されたスキルで非表示にしているスキル以外を取得
        else
            return SkillMaster.left_outer_joins(:skills).where(skills: {user_id: user_id, display_flg: [nil,0]}).group_by {|g| g.id}
        end
    end

    # 他ユーザーに追加されたスキルの一覧を取得
    def get_skill_id_other_user_add_skill_to_me user_id
        return Skill.where('user_id != create_skill_user_id').where(user_id: user_id).group_by {|g| g.skill_master_id}
    end

    # 各スキルに対して、推薦数を取得
    def get_user_recommend_count owner_user_id, user_has_skills
        # 対象ユーザーが所有している各スキルの推薦数を各スキルごとにグループ分けして取得。この時誰からも推薦されていないスキルはレコードが存在しない。なので、誰からも推薦されていないスキルは後から追加。
        user_recommend_count_each_skills = SkillRecommend.where(owner_user_id: owner_user_id, recommend_flg: 1).where.not(skill_master_id: nil).group(:skill_master_id).count
        # スキルの推薦数を降順でソート。
        user_recommend_count_each_skills = Hash[ user_recommend_count_each_skills.sort_by{ |_, v| -v } ]
        # 誰からも推薦されていないスキルを追加
        user_has_skills.each do |skill_key,skill_val|
            user_recommend_count_each_skills.store(skill_key, skill_val)
        end
        return user_recommend_count_each_skills
    end

    # 同じスキルを保有しているユーザー達を取得
    def get_skill_recommend_count owner_user_id, user_has_skills
        return SkillRecommend.where(
            recommend_flg: 1,
            owner_user_id: owner_user_id,
            skill_master_id: user_has_skills.keys
          ).group_by {|g| g.skill_master_id}
    end
end