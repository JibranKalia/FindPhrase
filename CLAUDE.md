# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FindThePhrase is a Rails 8.0 application that helps parents of children with gestalt language processing and apraxia search through Little Bear episode transcripts. When children reference phrases from the show, parents can search to understand the context and meaning.

## Key Commands

### Development Setup
```bash
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails transcripts:import  # Import transcript files from /transcripts directory
bin/dev  # Start development server with Foreman
```

### Database Operations
```bash
bin/rails db:reset transcripts:import  # Reset database and reimport all transcripts
bin/rails c  # Rails console for debugging/testing queries
```

### Code Quality
```bash
bundle exec rubocop  # Ruby style linting
bundle exec brakeman  # Security vulnerability scanning
bin/rails test  # Run test suite
bin/rails test:system  # Run system tests with Capybara/Selenium
```

### Asset Pipeline
```bash
bin/rails tailwindcss:build  # Build Tailwind CSS
bin/rails assets:precompile  # Precompile assets for production
```

## Architecture Overview

### Data Model
- **Episode**: Contains season/episode metadata (S01E01, etc.)
- **TranscriptSegment**: Individual dialogue segments with timestamps and position ordering
- Each episode has many transcript segments in sequential order
- Full-text search uses PostgreSQL's `pg_trgm` extension for fuzzy matching and `tsvector` for exact text search

### Search Implementation
The core search functionality spans multiple files:

**TranscriptSegment model** (`app/models/transcript_segment.rb`):
- Uses `pg_search` gem with dual search strategies:
  - `tsearch`: PostgreSQL full-text search with prefix matching
  - `trigram`: Fuzzy matching with 0.3 similarity threshold
- Combined ranking: `tsearch + (0.5 * trigram)`

**SearchController** (`app/controllers/search_controller.rb`):
- Two search modes: exact phrase (`LOWER(text) LIKE`) vs fuzzy (`search_text` scope)
- Returns context segments (3 before/after each match) for comprehension
- Groups results by episode to reduce cognitive load

**Search helpers** (`app/helpers/search_helper.rb`):
- Multi-level highlighting: bright yellow for full phrases, light yellow for individual words
- Popular search suggestions hardcoded from common Little Bear phrases

### Data Import Process
**Import rake task** (`lib/tasks/import_transcripts.rake`):
- Processes JSON files from `/transcripts/` directory
- Each file contains episode metadata plus array of dialogue segments with timestamps
- Destroys existing segments before reimport to handle updates
- Maintains segment position ordering for context retrieval

### Database Schema Notes
- `pg_trgm` extension enabled for trigram similarity matching
- GIN indexes on both `text` column (for full-text) and trigram operations
- Foreign key constraint between transcript_segments and episodes
- Unique index on episode_id to prevent duplicates

### Frontend Architecture
- Single-page search interface with Turbo/Stimulus (minimal JavaScript)
- TailwindCSS for responsive design
- Results show episode grouping with expandable context around matches
- Progressive enhancement: works without JavaScript, enhanced with it

## Development Notes

### Transcript File Format
Transcript files in `/transcripts/` follow naming pattern `S##E##_cleaned.json` and contain:
- Episode metadata (season, episode_number, duration, word_count)
- Segments array with text, timestamps, and word counts
- Used for seeding/updating database content

### Search Performance
- Database indexes optimized for both exact and fuzzy text search
- Results limited to 100 matches to prevent overwhelming interface
- Context retrieval uses position-based ranges rather than separate queries

### Accessibility Considerations
- Interface designed for parents who may be stressed or multitasking
- Large, clear search interface with immediate visual feedback
- Context provided around matches to aid comprehension
- Popular phrases suggested for quick discovery