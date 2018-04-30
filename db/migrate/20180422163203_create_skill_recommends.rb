class CreateSkillRecommends < ActiveRecord::Migration[5.1]
  def change
    create_table :skill_recommends do |t|
      t.integer :owner_user_id
      t.references :user
      t.references :skill_master

      t.integer :recommend_flg
      t.timestamps
    end
    
  end
end