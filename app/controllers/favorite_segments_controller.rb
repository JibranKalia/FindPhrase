class FavoriteSegmentsController < ApplicationController
  def index
    @favorite_segments = FavoriteSegment.includes(transcript_segment: :episode)
                                       .order(created_at: :desc)
    
    # Group by episode for better organization
    @grouped_favorites = @favorite_segments.group_by { |fav| fav.transcript_segment.episode }
  end
  
  def create
    @transcript_segment = TranscriptSegment.find(params[:transcript_segment_id])
    
    unless @transcript_segment.favorited?
      FavoriteSegment.create!(transcript_segment: @transcript_segment)
    end
    
    redirect_back(fallback_location: root_path, notice: "Added segment to favorites")
  rescue ActiveRecord::RecordNotFound
    redirect_back(fallback_location: root_path, alert: "Segment not found")
  end
  
  def destroy
    @transcript_segment = TranscriptSegment.find(params[:transcript_segment_id])
    
    if @transcript_segment.favorite_segment
      @transcript_segment.favorite_segment.destroy
      redirect_back(fallback_location: root_path, notice: "Removed segment from favorites")
    else
      redirect_back(fallback_location: root_path, notice: "Segment was not favorited")
    end
  rescue ActiveRecord::RecordNotFound
    redirect_back(fallback_location: root_path, alert: "Segment not found")
  end
end
