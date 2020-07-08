# Gemfile
########################################
inject_into_file 'Gemfile', after: "group :development, :test do\n" do
  <<-RUBY
    # Use RSpec and Factory Bot as testing tools
    gem 'factory_bot_rails'
    gem 'rspec-rails', '~> 4.0.0'
  RUBY
end

inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    # Use Active Admin as administration framework
    gem 'activeadmin'
    gem 'devise'

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
  # CMS: Devise + Active Admin
  ########################################
  file 'assets/config/manifest.js', <<~CODE
    {}
  CODE
  rails_command 'g active_admin:install'

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

  file 'spec/factories.rb', <<~RUBY
    FactoryBot.define do
    end
  RUBY

  # Generators: DB
  ########################################
  rails_command 'db:drop db:create db:migrate db:seed'

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT

    # Ignore .env file containing credentials.
    .env*

    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store

    # Ignore public, as it is built on deploy
    # Place files for /public in /client/public
    /public
  TXT

  # Dotenv
  ########################################
  run 'touch .env'

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with api template from https://github.com/ma-thibaud/rails-templates'"
end
