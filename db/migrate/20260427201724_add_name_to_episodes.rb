class AddNameToEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_column :episodes, :name, :string
  end
end
