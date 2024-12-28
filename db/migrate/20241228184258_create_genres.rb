class CreateGenres < ActiveRecord::Migration[7.2]
  def up
    create_table :genres do |t|
      t.string :name, null: false

      t.timestamps
    end
  end

  def def(down)
    drop_table :genres
  end
end
