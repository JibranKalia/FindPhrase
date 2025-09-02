module SearchHelper
  def highlight_matches(text, query)
    return text if query.blank?

    # Split query into words for multi-word highlighting
    words = query.split(/\s+/)
    highlighted_text = text

    # Highlight full phrase first (in bright yellow)
    if query.include?(" ")
      highlighted_text = highlighted_text.gsub(/(#{Regexp.escape(query)})/i) do |match|
        content_tag(:mark, match, class: "bg-yellow-300 font-bold px-1 rounded shadow-sm")
      end
    end

    # Then highlight individual words (in lighter yellow)
    words.each do |word|
      next if word.length < 2 # Skip very short words
      highlighted_text = highlighted_text.gsub(/(#{Regexp.escape(word)})/i) do |match|
        # Don't re-highlight if already in a mark tag
        if match.start_with?("<mark") || match.end_with?("</mark>")
          match
        else
          content_tag(:mark, match, class: "bg-yellow-100 px-0.5 rounded")
        end
      end
    end

    highlighted_text.html_safe
  end

  def format_timestamp(timestamp)
    return "" if timestamp.blank?
    # Format timestamp nicely (assumes format like "00:01:23")
    timestamp
  end

  def search_suggestions
    [
      "nobody knows",
      "mother bear",
      "little bear",
      "going to the moon",
      "hide and seek",
      "good morning",
      "I'm hungry",
      "once upon a time",
      "let's play",
      "what could be scarier"
    ]
  end
end
