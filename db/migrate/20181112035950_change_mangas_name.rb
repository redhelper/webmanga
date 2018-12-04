class ChangeMangasName < ActiveRecord::Migration[5.2]
  def change
  	rename_table :mangas, :series
  end
end
