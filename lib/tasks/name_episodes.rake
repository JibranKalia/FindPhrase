namespace :transcripts do
  desc "Backfill episode names from the canonical Little Bear story-title list"
  task name_episodes: :environment do
    # Each broadcast episode bundles 3 short stories. Titles per Wikipedia.
    names = {
      "S01E01" => "What Will Little Bear Wear? · Hide and Seek · Little Bear Goes to the Moon",
      "S01E02" => "Birthday Soup · Polar Bear · Gone Fishing",
      "S01E03" => "Up All Night · Little Bear's Bath · Father Bear Comes Home",
      "S01E04" => "A Flu · Exploring · Fishing with Father Bear",
      "S01E05" => "Little Bear's Wish · Little Bear's Shadow · A Present for Mother Bear",
      "S01E06" => "To Grandmother's House · Grandfather Bear · Mother Bear's Robin",
      "S01E07" => "Hiccups · Date with Father Bear · Pudding Hill",
      "S01E08" => "Little Bear's Mermaid · Father's Flying Flapjacks · Maracas",
      "S01E09" => "A Family Portrait · Little Bear's New Friend · Emily's Visit",
      "S01E10" => "Duck, Baby Sitter · Little Bear's Band · Hop Frog Pond",
      "S01E11" => "Little Bear and the Wind · The Goblin Story · Not Tired",
      "S01E12" => "Grandfather's Attic · Little Bear's Egg · Party at Owl's House",
      "S01E13" => "The Rain Dance Play · Your Friend, Little Bear · Fall Dream",

      "S02E01" => "Little Bear the Magician · Doctor Little Bear · Bigger Little Bear",
      "S02E02" => "Little Bear's Trip to the Stars · Little Bear's Surprise · Little Bear and the North Pole",
      "S02E03" => "Cat's Short Cut · Little Bear's Bad Day · Captain Little Bear",
      "S02E04" => "Little Bear Meets No Feet · The Camp Out · Emily's Balloon",
      "S02E05" => "Building a House for Emily · Emily Returns · Little Sherlock Bear",
      "S02E06" => "Little Bear's Tooth · Little Red Riding Hood · Little Bear and the Cupcakes",
      "S02E07" => "Snowball Fight · Winter Solstice · Snowbound",
      "S02E08" => "Little Bear's Garden · Prince Little Bear · A Painting for Emily",
      "S02E09" => "Follow the Leader · Little Scarecrow Bear · Little Bear and the Baby",
      "S02E10" => "Rafting on the River · Little Bear's Kite · Night of the Full Moon",
      "S02E11" => "Auntie Hen · Play Ball · Lucy's Okay",
      "S02E12" => "Between Friends · The Blueberry Picnic · Lucy Needs a Friend",
      "S02E13" => "Picnic on Pudding Hill · Little Bear's Walkabout · Secret Friend",

      "S03E01" => "Owl's Dilemma · School for Otters · Spring Cleaning",
      "S03E02" => "Whale of a Tale · Mitzi Arrives · Granny's Old Flying Rug",
      "S03E03" => "Little Bear Sing a Song · A House for Mitzi · Up a Tree",
      "S03E04" => "The Big Bear Sitter · The Top of the World · The Campfire Tale",
      "S03E05" => "Mitzi's Little Monster · Simon Says · Applesauce",
      "S03E06" => "Father Bear's Nightshirt · How to Scare Ghosts · Search for Spring",
      "S03E07" => "Out of Honey · Message in a Bottle · Little Bear's Sweet Tooth",
      "S03E08" => "Where Lucy Went · Monster Pudding · Under the Covers",
      "S03E09" => "Gingerbread Cookies · Marbles · The Garden War",
      "S03E10" => "The Red Thread · Princess Duck · Little Bear Meets Duck",
      "S03E11" => "Mother Nature · Dance Steps · Who Am I?",
      "S03E12" => "Emily's Birthday · The Great Race · Circus for Tutu",
      "S03E13" => "Clever Cricket · Leaves · Big Bad Broom",

      "S04E01" => "Moonlight Serenade · Caterpillars · Goblin Night",
      "S04E02" => "Little Bear and the Sea Monster · Hat Parade · Finding Fisherman Bear",
      "S04E03" => "Pillow Hill · Diva Hen · Father Bear's Little Helper",
      "S04E04" => "I'll Be You, You'll Be Me · Frog in My Throat · The Puddle Jumper",
      "S04E05" => "Family Bath Time · Winter Wonderland · Mitzi's Mess",
      "S04E06" => "Sleep Over · Sandcastles · Happy Anniversary",
      "S04E07" => "The April Fool · Balloon Heads · Mother Bear's Button",
      "S04E08" => "Little Bear and the Ice Boat · Baby Deer · Invisible Little Bear",
      "S04E09" => "Blue Feather · Thunder Monster · Duck Soup",
      "S04E10" => "Little White Skunk · Mother's Day · Little Footprint",
      "S04E11" => "Valentines Day · Thinking of Mother Bear · I Spy",
      "S04E12" => "Rainy Day Friends · Little Goblin Bear · Picnic on the Moon",
      "S04E13" => "The Painting · The Kiss · The Wedding",

      "S05E01" => "Duck Loses Her Quack · Feathers in a Bunch · Detective Little Bear",
      "S05E02" => "The Sky Is Falling · Father's Day · Fisherman Bear's Big Catch",
      "S05E03" => "The Dandelion Wish · The Broken Boat · Duck Takes the Cake",
      "S05E04" => "Little Bear Talks to Himself · Who Do I Look Like? · Mister Nobody",
      "S05E05" => "I Can Do That · Pied Piper Little Bear · The Big Swing",
      "S05E06" => "The Greatest Show in the World · Lucky Little Bear · Little Bear's Tall Tale",
      "S05E07" => "Little Bear Scares Everyone · The One that Got Away · Where Are Little Bear's Crayons?",
      "S05E08" => "Magic Lemonade · Silly Billy · Goodnight, Little Bear",
      "S05E09" => "First Frost · Hello Snow · Duck and the Winter Moon",
      "S05E10" => "Opposites Day · Wish upon a Star · Sleepy Head Monster",
      "S05E11" => "Little Bear's Favorite Tree · Something Old, Something New · In a Little While",
      "S05E12" => "We're Lost · Little Little Bear · Duck's Big Catch",
      "S05E13" => "How to Love a Porcupine · A Houseboat for Duck · How Little Bear Met Owl",

      # Winter compilation — re-runs of three earlier stories.
      "S05E14" => "Winter Special: Little Bear and the North Pole · Hello Snow · Gingerbread Cookies"
    }

    updated = 0
    missing = []
    names.each do |episode_id, name|
      episode = Episode.find_by(episode_id: episode_id)
      if episode
        episode.update!(name: name)
        updated += 1
      else
        missing << episode_id
      end
    end

    puts "Named #{updated} episodes."
    puts "Missing from DB: #{missing.join(', ')}" if missing.any?

    unnamed = Episode.where(name: nil).pluck(:episode_id)
    puts "In DB but no canonical title: #{unnamed.join(', ')}" if unnamed.any?
  end
end
