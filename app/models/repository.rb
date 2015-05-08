class Repository < ActiveRecord::Base
has_many :issues,dependent: :destroy
has_many :milestones,dependent: :destroy
has_many :lables,dependent: :destroy
has_many :contributors,dependent: :destroy
end
