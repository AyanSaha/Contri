class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.string :color
      t.references :repository, index: true

      t.timestamps null: false
    end
    add_foreign_key :labels, :repositories
  end
end
