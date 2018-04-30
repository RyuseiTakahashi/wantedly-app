class SkillMaster < ApplicationRecord
    has_many :skill_recommends
    has_many :skills
end
