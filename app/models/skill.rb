class Skill < ApplicationRecord
    belongs_to :skill_master
    belongs_to :user
end
