class CreateIssueLabels < ActiveRecord::Migration
  def change
    create_table :issue_labels do |t|
      t.references :issue, index: true
      t.references :label, index: true
      t.references :repository, index: true

      t.timestamps null: false
    end
    add_foreign_key :issue_labels, :issues
    add_foreign_key :issue_labels, :labels
    add_foreign_key :issue_labels, :repositories
  end
end
