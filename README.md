# FindThePhrase

A Rails application that helps parents of children with gestalt language processing and apraxia search through Little Bear episode transcripts. When children reference phrases from the show, parents can quickly find the context and understand what their child is communicating.

## Features

- **Fast Search**: Full-text search with fuzzy matching for approximate phrases
- **Context Aware**: Shows dialogue before and after matches for better comprehension  
- **Episode Coverage**: Searchable transcripts for Little Bear Seasons 1-5
- **Exact Matching**: Toggle between fuzzy search and exact phrase matching
- **Mobile Friendly**: Responsive design for quick searches on any device

## Setup

### Requirements
- Ruby 3.3+
- PostgreSQL 14+ (with pg_trgm extension)
- Node.js (for asset pipeline)

### Installation

```bash
# Clone and setup
bundle install
bin/rails db:create
bin/rails db:migrate

# Import transcript data
bin/rails transcripts:import

# Start development server
bin/dev
```

### Usage

1. Visit http://localhost:3000
2. Enter a phrase your child said (e.g., "duck", "nobody knows")
3. View results with episode context and timestamps
4. Use exact match toggle for precise phrase searches

## Technical Details

- **Framework**: Rails 8.0 with PostgreSQL
- **Search**: pg_search gem with trigram similarity matching
- **Frontend**: TailwindCSS with Turbo/Stimulus
- **Data**: JSON transcript files imported via Rake tasks

## Development

```bash
# Run tests
bin/rails test

# Code quality
bundle exec rubocop
bundle exec brakeman

# Reset data
bin/rails db:reset transcripts:import
```
