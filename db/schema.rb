# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_01_213206) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "episodes", force: :cascade do |t|
    t.string "episode_id"
    t.integer "season"
    t.integer "episode_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["episode_id"], name: "index_episodes_on_episode_id", unique: true
  end

  create_table "transcript_segments", force: :cascade do |t|
    t.bigint "episode_id", null: false
    t.text "text"
    t.string "timestamp_from"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, text)", name: "idx_segments_text_fts", using: :gin
    t.index ["episode_id", "position"], name: "index_transcript_segments_on_episode_id_and_position"
    t.index ["episode_id"], name: "index_transcript_segments_on_episode_id"
    t.index ["text"], name: "idx_segments_text_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  add_foreign_key "transcript_segments", "episodes"
end
