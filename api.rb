# Gemfile
########################################
inject_into_file 'Gemfile', after: 'group :development, :test do' do
  <<~RUBY
  # Use RSpec as the testing tool
  gem 'rspec-rails', '~> 4.0.0'
  RUBY
end

# README
########################################
markdown_file_content = <<~MARKDOWN
  Rails app generated with [ma-thibaud/rails-templates](https://github.com/ma-thibaud/rails-templates), created by the Mathias Thibaud.
MARKDOWN
file 'README.md', markdown_file_content, force: true

########################################
# AFTER BUNDLE
########################################

after_bundle do
  # Generators: DB + RSpec
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate 'rspec:install'
  
  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT

    # Ignore .env file containing credentials.
    .env*

    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
  TXT

  # Dotenv
  ########################################
  run 'touch .env'

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with api template from https://github.com/ma-thibaud/rails-templates'"
end
