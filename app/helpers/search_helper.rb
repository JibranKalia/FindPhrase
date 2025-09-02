module SearchHelper
  def highlight_matches(text, query)
    return text if query.blank?

    # Split query into words for multi-word highlighting
    words = query.split(/\s+/)
    highlighted_text = text

    # Highlight matching words with blue
    words.each do |word|
      next if word.length < 2 # Skip very short words
      highlighted_text = highlighted_text.gsub(/(#{Regexp.escape(word)})/i) do |match|
        content_tag(:mark, match, class: "bg-blue-200 font-medium px-1 rounded")
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
