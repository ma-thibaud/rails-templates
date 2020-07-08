# Gemfile
########################################
gem_group :development, :test do
  gem 'rspec-rails', '~> 4.0.0'

  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end

file '.rubocop.yml', <<-CODE
require:
  - rubocop-rails
  - rubocop-performance

AllCops:
  Exclude:
    - node_modules/**/*
    - db/**
    - db/migrate/**
    - bin/**
    - vendor/**/*

Layout/LineLength:
  Max: 120

Metrics/BlockLength:
  Exclude:
    - config/**/*

Style/Documentation:
  Enabled: false
CODE

after_bundle do
  generate 'rspec:install'
  run 'bundle exec rubocop --auto-gen-config'
end

# Dotenv
########################################
run 'touch .env'

# Git
########################################
git add: '.'
git commit: "-m 'Initial commit with personal template'"
