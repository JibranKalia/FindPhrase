class TranscriptSegment < ApplicationRecord
  belongs_to :episode
  has_one :favorite_segment, dependent: :destroy

  include PgSearch::Model

  pg_search_scope :search_text,
    against: :text,
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english",
        any_word: false
      },
      trigram: {
        threshold: 0.5
      }
    },
    ranked_by: ":tsearch * 2 + :trigram"

  scope :ordered, -> { order(:position) }

  def display_location
    "#{episode.episode_id} at #{timestamp_from}"
  end

  def favorited?
    favorite_segment.present?
  end
end
