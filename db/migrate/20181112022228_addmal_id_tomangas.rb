class AddmalIdTomangas < ActiveRecord::Migration[5.2]
  def change
  	add_column :mangas, :mal_id, :integer
  end
end
