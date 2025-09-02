namespace :transcripts do
  desc "Import cleaned transcript files into database"
  task import: :environment do
    Dir.glob("transcripts/*_cleaned.json").each do |file|
      puts "Processing #{file}..."
      
      data = JSON.parse(File.read(file))

      # Find or create episode
      episode = Episode.find_or_create_by!(
        episode_id: data['episode_id']
      ) do |e|
        e.season = data['season'].to_i
        e.episode_number = data['episode_number'].to_i
      end

      # Delete existing segments for this episode
      episode.transcript_segments.destroy_all

      # Import segments
      data['segments'].each_with_index do |segment, index|
        episode.transcript_segments.create!(
          text: segment['text'],
          position: index,
          timestamp_from: segment['timestamp_from']
        )
      end

      puts "Imported #{episode.episode_id}: #{data['segments'].length} segments"
    end
    
    puts "Import complete!"
  end
end