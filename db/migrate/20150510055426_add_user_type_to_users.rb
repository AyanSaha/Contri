class AddUserTypeToUsers < ActiveRecord::Migration
  def change
  add_column :users, :github_user_type, :string
  end
end
