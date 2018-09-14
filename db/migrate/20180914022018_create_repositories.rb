class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :nodeid
      t.string :name
      t.string :full_name
      t.integer :owner_id
      t.string :html_url
      t.text :description
      t.integer :stargazers_count

      t.timestamps
    end
  end
end
