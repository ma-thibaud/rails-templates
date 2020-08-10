# Application Controller
########################################
application_controller_file_content = <<~RUBY
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
RUBY
file 'app/controllers/application_controller.rb', application_controller_file_content, force: true

file 'app/controllers/api_controller.rb', <<~RUBY
  class ApiController < ActionController::API
  end
RUBY

# Application
########################################
gsub_file 'config/application.rb', '# require "sprockets/railtie"', 'require "sprockets/railtie"'

inject_into_file 'config/application.rb', after: "config.api_only = true\n" do
  <<-RUBY
    # Middleware for ActiveAdmin
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  RUBY
end

# Manifest
########################################
file 'app/assets/config/manifest.js', <<~CODE
  {}
CODE

# Gemfile
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    # Use Active Admin as administration framework
    gem 'activeadmin'
    gem 'devise'
  RUBY
end

inject_into_file 'Gemfile', after: "group :development, :test do\n" do
  <<-RUBY
  # Use RSpec and Factory Bot as testing tools
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker', git: 'https://github.com/stympy/faker'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'shoulda-matchers', '~> 3.1'
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

  # CMS: Devise + Active Admin
  ########################################
  run 'rails g active_admin:install'
  rails_command 'db:migrate db:seed'

  gsub_file 'db/seeds.rb', ' if Rails.env.development?', ''

  # Testing: RSpec + Factory Bot
  ########################################
  generate 'rspec:install'

  file 'spec/support/factory_bot.rb', <<~RUBY
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY

  rails_helper_file_content = <<~RUBY
    ENV['RAILS_ENV'] ||= 'test'
    require File.expand_path('../config/environment', __dir__)

    abort("The Rails environment is running in production mode!") if Rails.env.production?
    require 'spec_helper'
    require 'rspec/rails'
    require 'database_cleaner'

    Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

    begin
      ActiveRecord::Migration.maintain_test_schema!
    rescue ActiveRecord::PendingMigrationError => e
      puts e.to_s.strip
      exit 1
    end

    RSpec.configure do |config|
      config.use_transactional_fixtures = false
      config.include Devise::Test::ControllerHelpers, type: :controllers
      config.include Devise::Test::IntegrationHelpers, type: :request
      config.infer_spec_type_from_file_location!
      config.filter_rails_from_backtrace!
    end
  RUBY

  file 'spec/rails_helper.rb', rails_helper_file_content, force: true

  file 'spec/support/database_cleaner.rb', <<~RUBY
    RSpec.configure do |config|
      config.before(:suite) do
        DatabaseCleaner.clean_with(:truncation)
      end

      config.before(:each) do
        DatabaseCleaner.strategy = :transaction
      end

      config.before(:each, js: true) do
        DatabaseCleaner.strategy = :truncation
      end

      config.before(:each) do
        DatabaseCleaner.start
      end

      config.after(:each) do
        DatabaseCleaner.clean
      end

      config.before(:all) do
        DatabaseCleaner.start
      end

      config.after(:all) do
        DatabaseCleaner.clean
      end
    end
  RUBY

  file 'spec/support/shoulda_matchers.rb', <<~RUBY
    Shoulda::Matchers.configure do |config|
      config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
      end
    end
  RUBY

  inject_into_file 'config/environments/test.rb', after: "end\n" do
    <<~RUBY
      
      Rails.application.config.middleware.insert_before Warden::Manager, ActionDispatch::Cookies
      Rails.application.config.middleware.insert_before Warden::Manager, ActionDispatch::Session::CookieStore
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
    # Ignore public, as it is built on deploy
    # Place files for /public in /client/public
    /public
  TXT

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'curl -L   https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/.rubocop.yml > .rubocop.yml'
  
  # React
  ########################################
  run 'npx create-react-app client'
  
  index_js_file_content = <<~RUBY
    import React from 'react';
    import ReactDOM from 'react-dom';
    import './index.css';
    import App from './App';

    ReactDOM.render(
      <React.StrictMode>
        <App />
      </React.StrictMode>,
      document.getElementById('root')
    );
  RUBY
  file 'client/src/index.js', index_js_file_content, force: true

  inject_into_file 'client/package.json', before: '"dependencies"' do
    <<~CODE
      "proxy": "http://localhost:3001",
    CODE
  end

  # Procfile
  ########################################
  file 'Procfile.dev', <<~CODE
    web: PORT=3000 yarn --cwd client start
    api: PORT=3001 bundle exec rails s  
  CODE

  file 'lib/tasks/start.rake', <<~CODE
    namespace :start do
      task :development do
        exec 'heroku local -f Procfile.dev'
      end
    end

    desc 'Start development server'
    task :start => 'start:development'
  CODE

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with react template from https://github.com/ma-thibaud/rails-templates'"
end
