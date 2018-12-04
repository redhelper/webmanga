class AddpreviewTomangas < ActiveRecord::Migration[5.2]
  def change
  	add_column :mangas, :img, :string
  end
end
