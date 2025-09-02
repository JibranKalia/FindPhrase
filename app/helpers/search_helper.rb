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
    
    # Convert from "00:18:16,000" format to "18:16"
    if timestamp.match(/(\d{2}):(\d{2}):(\d{2}),?(\d{3})?/)
      hours = $1.to_i
      minutes = $2.to_i
      seconds = $3.to_i
      
      # For episodes under 30 minutes, show as MM:SS
      if hours == 0
        "#{minutes}:#{seconds.to_s.rjust(2, '0')}"
      else
        # For longer episodes, show full HH:MM:SS
        "#{hours}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
      end
    else
      timestamp
    end
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
