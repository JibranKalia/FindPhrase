class CreateTranscriptSegments < ActiveRecord::Migration[8.0]
  def change
    create_table :transcript_segments do |t|
      t.references :episode, null: false, foreign_key: true
      t.text :text
      t.string :timestamp_from
      t.integer :position

      t.timestamps
    end
    
    add_index :transcript_segments, [:episode_id, :position]
    
    # Full text search index
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    execute <<-SQL
      CREATE INDEX idx_segments_text_fts ON transcript_segments 
      USING gin(to_tsvector('english', text));
    SQL
    execute <<-SQL
      CREATE INDEX idx_segments_text_trgm ON transcript_segments 
      USING gin(text gin_trgm_ops);
    SQL
  end
end
