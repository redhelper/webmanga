class RemoveimgUrlFrommangas < ActiveRecord::Migration[5.2]
  def change
  	remove_column :mangas, :img_url 
  end
end
