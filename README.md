# Rails Templates
Jump start your Rails development with my personal templates.

## Testing
Get a Rails app ready to deploy with following testing tools:
- [RSpec](https://github.com/rspec/rspec-rails)
- [Factory Bot](https://github.com/thoughtbot/factory_bot_rails)

```bash
rails new \
--database postgresql \
-T \
-m https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/testing.rb \
CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

## API
Get a Rails API-only app ready to deploy with the following:
- Testing: [RSpec](https://github.com/rspec/rspec-rails) & [Factory Bot](https://github.com/thoughtbot/factory_bot_rails)
- CMS: [Devise](https://github.com/heartcombo/devise) & [Active Admin](https://github.com/activeadmin/activeadmin)


```bash
rails new \
--api \
--database postgresql \
-T \
-m https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/api.rb \
CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

Start the server, visit http://localhost:3000/admin and log in as the default user:
- User: admin@example.com
- Password: password

Create and register a new model:
```bash
rails generate model MyModel
rails db:migrate
rails generate active_admin:resource MyModel
```

## React
Get a Rails API-only app with a React front-end and the following:
- Testing: [RSpec](https://github.com/rspec/rspec-rails), [Factory Bot](https://github.com/thoughtbot/factory_bot_rails) & [Database Cleaner
](https://github.com/DatabaseCleaner/database_cleaner)
- Linter: [Rubocop](https://github.com/rubocop-hq/rubocop)
- CMS: [Devise](https://github.com/heartcombo/devise) & [Active Admin](https://github.com/activeadmin/activeadmin)


```bash
rails new \
--api \
--database postgresql \
-T \
-m https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/react.rb \
CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

Simply run:
```bash
bundle exec rake start
```

You can now access the app:
- Client: http://localhost:3000/
- Active Admin via API: http://localhost:3001/admin
