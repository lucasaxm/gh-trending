class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :nodeid
      t.string :login
      t.string :name
      t.integer :type_id
      t.string :avatar_url
      t.string :html_url

      t.timestamps
    end
  end
end
