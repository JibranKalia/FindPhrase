class Episode < ApplicationRecord
  has_many :transcript_segments, dependent: :destroy

  validates :episode_id, presence: true, uniqueness: true
  validates :season, :episode_number, presence: true

  def display_name
    episode_id
  end
end
