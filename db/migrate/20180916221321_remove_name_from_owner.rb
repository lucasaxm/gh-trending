class RemoveNameFromOwner < ActiveRecord::Migration[5.2]
  def change
    remove_column :owners, :name, :string
  end
end
