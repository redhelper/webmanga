class CreateMangas < ActiveRecord::Migration[5.2]
  def change
    create_table :mangas do |t|
      t.string :name
      t.text :about
      t.string :img_url

      t.timestamps
    end
  end
end
