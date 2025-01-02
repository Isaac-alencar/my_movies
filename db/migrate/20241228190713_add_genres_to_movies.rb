class AddGenresToMovies < ActiveRecord::Migration[7.2]
  def up
    add_reference :movies, :genres, foreign_key: true, index: true
  end

  def def
    remove_reference :movies, :genres, foreign_key: true, index: false
  end
end
