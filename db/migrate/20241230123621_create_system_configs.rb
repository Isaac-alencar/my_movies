class CreateSystemConfigs < ActiveRecord::Migration[7.2]
  def change
    create_table :system_configs do |t|
      t.string :key
      t.integer :value

      t.timestamps
    end
  end
end
