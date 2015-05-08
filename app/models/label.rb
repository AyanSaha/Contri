class Label < ActiveRecord::Base
has_and_belongs_to :issues
belongs_to :repository
end
