class User < ActiveRecord::Base
 def self.find_or_create_with_omniauth(auth)
    create! do |user|
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
  end
 end
end