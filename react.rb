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

  # CMS: Devise + Active Admin
  ########################################
  run 'rails g active_admin:install'
  rails_command 'db:migrate db:seed'

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

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with react template from https://github.com/ma-thibaud/rails-templates'"
end
