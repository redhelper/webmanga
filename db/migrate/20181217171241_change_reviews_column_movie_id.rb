class ChangeReviewsColumnMovieId < ActiveRecord::Migration[5.2]
  def change
    rename_column :reviews, :movie_id, :manga_id
  end
end
