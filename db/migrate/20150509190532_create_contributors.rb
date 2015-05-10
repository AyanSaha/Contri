class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.integer :total_contributions
      t.integer :recent_contributions
      t.integer :repository_id
      t.references :repository, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :contributors, :repositories
    add_foreign_key :contributors, :users
  end
end
