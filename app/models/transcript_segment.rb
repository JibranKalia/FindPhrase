class TranscriptSegment < ApplicationRecord
  belongs_to :episode

  include PgSearch::Model

  pg_search_scope :search_text,
    against: :text,
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english"
      },
      trigram: {
        threshold: 0.3
      }
    },
    ranked_by: ":tsearch + (0.5 * :trigram)"

  scope :ordered, -> { order(:position) }

  def display_location
    "#{episode.episode_id} at #{timestamp_from}"
  end
end
