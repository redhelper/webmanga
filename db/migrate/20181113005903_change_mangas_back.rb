class ChangeMangasBack < ActiveRecord::Migration[5.2]
  def change
  	rename_table :series, :mangas
  end
end
