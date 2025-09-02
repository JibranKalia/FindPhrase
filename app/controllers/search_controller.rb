# /Users/jibran.kalia/side/FindThePhrase2/app/controllers/search_controller.rb

class SearchController < ApplicationController
  def index
    @query = params[:query]&.strip
    @results = []
    @grouped_results = {}
    @total_matches = 0

    if @query.present?
      # Use pg_search with phrase matching
      matches = TranscriptSegment
        .search_text(@query)
        .includes(:episode, :favorite_segment)
        .limit(100)

      @total_matches = matches.count

      # Get context segments (before and after each match)
      @results = matches.map do |match|
        episode = match.episode
        # Get context (2 segments before and after)
        context_segments = episode.transcript_segments
          .where(position: (match.position - 2)..(match.position + 2))
          .includes(:favorite_segment)
          .ordered

        {
          match: match,
          context_segments: context_segments,
          episode: episode
        }
      end

      @grouped_results = @results.group_by { |result| result[:episode] }
    end
  end
end
