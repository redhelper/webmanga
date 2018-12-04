class AddMTypeToMangas < ActiveRecord::Migration[5.2]
  def change
    add_column :mangas, :m_type, :string
  end
end
