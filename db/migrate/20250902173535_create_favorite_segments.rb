class CreateFavoriteSegments < ActiveRecord::Migration[8.0]
  def change
    create_table :favorite_segments do |t|
      t.references :transcript_segment, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :favorite_segments, :transcript_segment_id, unique: true, name: 'index_favorite_segments_on_segment_id_unique'
  end
end
