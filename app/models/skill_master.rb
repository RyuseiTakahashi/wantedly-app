class SkillMaster < ApplicationRecord
    has_many :skill_recommends, dependent: :destroy
    has_many :skills, dependent: :destroy
end
