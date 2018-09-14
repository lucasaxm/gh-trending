class AddLanguageIdToRepository < ActiveRecord::Migration[5.2]
  def change
    add_column :repositories, :language_id, :integer
  end
end
