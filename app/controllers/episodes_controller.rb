class EpisodesController < ApplicationController
  def show
    @episode = Episode.find_by!(episode_id: params[:id])
    @transcript_segments = @episode.transcript_segments.ordered
    @target_segment_id = params[:segment]
  end
end