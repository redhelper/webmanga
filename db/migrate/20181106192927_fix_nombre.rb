class FixNombre < ActiveRecord::Migration[5.2]
  def change
  	rename_column :mangas, :name, :title
  end
end
