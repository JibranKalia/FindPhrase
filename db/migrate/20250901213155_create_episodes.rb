class CreateEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_table :episodes do |t|
      t.string :episode_id
      t.integer :season
      t.integer :episode_number

      t.timestamps
    end
    add_index :episodes, :episode_id, unique: true
  end
end
