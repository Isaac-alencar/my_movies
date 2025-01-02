class CreateMovies < ActiveRecord::Migration[7.2]
  def up
    create_table :movies do |t|
      t.integer :tmdb_id, null: false
      t.string :title, null: false
      t.text :overview, null: false
      t.string :poster_path, null: false
      t.string :release_date, null: false
      t.float :vote_average, null: false
      t.integer :vote_count, null: false

      t.timestamps
    end
  end

  def down
    drop_table :movies
  end
end
