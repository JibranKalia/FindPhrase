# /Users/jibran.kalia/side/FindThePhrase2/app/controllers/search_controller.rb

class SearchController < ApplicationController
  def index
    @query = params[:query]&.strip
    @exact_match = params[:exact_match] == "true"
    @results = []
    @grouped_results = {}
    @total_matches = 0

    if @query.present?
      # Use exact phrase search or regular search
      if @exact_match
        # Search for exact phrase
        matches = TranscriptSegment
          .where("LOWER(text) LIKE ?", "%#{@query.downcase}%")
          .includes(:episode)
          .limit(100)
      else
        # Use full-text search
        matches = TranscriptSegment
          .search_text(@query)
          .includes(:episode)
          .limit(100)
      end

      @total_matches = matches.count

      # Get context segments (before and after each match)
      @results = matches.map do |match|
        episode = match.episode
        # Get more context (3 segments before and after)
        context_segments = episode.transcript_segments
          .where(position: (match.position - 3)..(match.position + 3))
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
