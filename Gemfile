source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the default database for Active Record
gem "sqlite3", ">= 2.1"
# Use pg when DATABASE_URL points to a PostgreSQL database
gem "pg", require: false
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "rspec-rails", "~> 8.0.0"
  gem "simplecov", require: false, group: :test
  gem "simplecov-cobertura"
  gem "factory_bot_rails"
end

group :test do
  gem "shoulda-matchers", "~> 8.0"
  gem "database_cleaner-active_record"
  gem "turnip"
  gem "capybara"
  gem "capybara-screenshot"
  gem "cuprite"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "bullet"
  gem "letter_opener"
end

group :production do
  gem "solid_errors", "~> 0.7.0"
end

gem "ruby_ui", "~> 1.2", group: :development, require: false

gem "phlex-rails", "~> 2.4"

gem "tailwind_merge", "~> 1.5"

gem "tailwindcss-rails", "~> 4.4"

gem "link_thumbnailer", "~> 3.4"

gem "fastimage", "~> 2.4"

gem "mini_magick", "~> 5.3"

gem "pundit", "~> 2.5"

gem "faraday", "~> 2.14"
gem "faraday-retry"
gem "faraday-follow_redirects", "~> 0.5.0"

gem "validate_url", "~> 1.0"

gem "ferrum", "~> 0.17.2"

gem "figaro", "~> 1.3"

gem "mission_control-jobs", "~> 1.1"

gem "store_model", "~> 4.6"

gem "active_storage_validations", "~> 3.0"

gem "pagy", "~> 43.5"

gem "marksmith", "~> 0.5.2"
gem "commonmarker", "~> 2.8"

gem "data_migrate", "~> 11.3"

gem "active_storage-blurhash"

gem "aws-sdk-s3", require: false

gem "search_cop", "~> 1.5"

gem "meta-tags", "~> 2.23"

gem "kmeans-clusterer", "~> 0.11.4"

gem "color", "~> 2.2"

gem "trailblazer-rails", "~> 2.4"
