# Gemfile
########################################
inject_into_file 'Gemfile', after: "group :development, :test do\n" do
  <<-RUBY
  # Use RSpec and Factory Bot as testing tools
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0.0'
  RUBY
end

# README
########################################
markdown_file_content = <<~MARKDOWN
  Rails app generated with [ma-thibaud/rails-templates](https://github.com/ma-thibaud/rails-templates), created by Mathias Thibaud.
MARKDOWN
file 'README.md', markdown_file_content, force: true

########################################
# AFTER BUNDLE
########################################

after_bundle do
  # Generators: DB
  ########################################
  rails_command 'db:create'
  
  # Testing: RSpec + Factory Bot
  ########################################
  generate 'rspec:install'

  file 'spec/support/factory_bot.rb', <<~RUBY
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY

  inject_into_file 'spec/rails_helper.rb', after: "# Add additional requires below this line. Rails is not loaded until this point!\n" do
    <<~RUBY
      require 'support/factory_bot'
    RUBY
  end

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

  # Rubocop
  ########################################
  run 'curl -L   https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/.rubocop.yml > .rubocop.yml'

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with testing template from https://github.com/ma-thibaud/rails-templates'"
end
