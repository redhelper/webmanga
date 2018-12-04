class AddUserIdToMangas < ActiveRecord::Migration[5.2]
  def change
    add_column :mangas, :user_id, :integer
  end
end
