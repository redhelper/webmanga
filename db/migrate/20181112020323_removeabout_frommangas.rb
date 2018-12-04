class RemoveaboutFrommangas < ActiveRecord::Migration[5.2]
  def change
  	remove_column :mangas, :about 
  end
end
