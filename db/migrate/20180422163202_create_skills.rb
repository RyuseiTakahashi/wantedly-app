class CreateSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :skills do |t|
      t.references :skill_master
      t.references :user

      t.timestamps
    end
  end
end
